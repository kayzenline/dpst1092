////////////////////////////////////////////////////////////////////////////////
// DPST1092 25T1 --- Assignment 2: `cursed', a file encryption tool
// <https://www.cse.unsw.edu.au/~dp1092/25T2/assignments/ass2/index.html>
//
// This program was written by JIAWEN LIN (z5647814) on 17/07/2025.
// (COMPLETE THE ABOVE COMMENT AND REMOVE THIS LINE FOR A FREE STYLE MARK!)

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "cursed.h"

// Add any extra #defines here.
#include <stdint.h>

// Add any extra function signatures here.
static void format_permissions(mode_t mode, char perm[11]);

static void search_file_recusion(char *dirpath,
                                   char *search_string, char *results[],
                                   int *count);

static void search_content_recusion(char *dirpath,
                                   char *pattern, int patlen,
                                  content_result *results[], int *count);

static long get_file_size(FILE *file);

// Some provided strings which you may find useful. Do not modify.
const char *const MSG_ERROR_FILE_STAT = "Could not stat file.\n";
const char *const MSG_ERROR_FILE_OPEN = "Could not open file.\n";
const char *const MSG_ERROR_CHANGE_DIR = "Could not change directory.\n";
const char *const MSG_ERROR_DIRECTORY =
    "cursed does not support directories.\n";
const char *const MSG_ERROR_READ =
    "group does not have permission to read this file.\n";
const char *const MSG_ERROR_WRITE =
    "group does not have permission to write here.\n";
const char *const MSG_ERROR_RESERVED =
    "'.' and '..' are reserved filenames. Please search for something else.\n";

/////////////////////////////////// SUBSET 0 ///////////////////////////////////

// Print the name of the current directory.
void print_current_directory(void) {
    char cwd[MAX_PATH_LEN];
    if(getcwd(cwd, sizeof(cwd)) == NULL) {
        fprintf(stderr, "%s", MSG_ERROR_FILE_STAT);
        return;
    }
    printf("The current directory is: %s\n", cwd);
}

// Change the current directory to the given pathname.
void change_current_directory(char *directory) {
    //I must also somehow actually move myself to that different directory.
    //1. You can keep track of where you are? (Update this?)
    //2. can I change my working directory somehow? (Using library)
    char path[MAX_PATH_LEN];

    // expand ~ to HOME
    if (directory[0] == '~') {
        char *home = getenv("HOME");
        if (directory[1] == '\0') {
            strcpy(path, home);
            path[sizeof(path) - 1] = '\0';
        } else if (directory[1] == '/') {
            sprintf(path, "%s%s", home, directory + 1);
        } else {
            printf("%s", MSG_ERROR_CHANGE_DIR);
            return;
        }
    } else {
        // use the provided path directly
        strcpy(path, directory);
        path[sizeof(path) - 1] = '\0';
    }

    // try to change directory
    if (chdir(path) != 0) {
        printf("%s", MSG_ERROR_CHANGE_DIR);
        return;
    }

    // report new directory
    //char cwd[MAX_PATH_LEN];
    if (directory[0] == '~') {
        printf("Moving to %s\n", path);
    } else {
        printf("Moving to %s\n", directory);
    }
    return;
}


// List the contents of the current directory.
void list_current_directory(void) {
    //Probably need a for loop
    //Go through everything in the current directory 1 by 1.
    //You need to print the file/dir name
    //You also need to figure out it's permissions. How will you do this?
    DIR * dirp = opendir(".");
    struct dirent *de;
    char *names[MAX_LISTINGS];
    int count = 0;
    struct stat st;
    while ((de = readdir(dirp)) != NULL && count < MAX_LISTINGS) {
        if (stat(de->d_name, &st) != 0) {
            printf("%s", MSG_ERROR_FILE_STAT);
            continue;
        }
        names[count] = strdup(de->d_name);
        count++;
    }
    closedir(dirp);
    sort_strings(names, count);
    for (int i = 0; i < count; i++) {
        if (stat(names[i], &st) != 0) {
            printf("%s", MSG_ERROR_FILE_STAT);
        }
        char perm[11];
        format_permissions(st.st_mode, perm);
        printf("%s\t%s\n", perm, names[i]);
        free(names[i]);
    }
}

/////////////////////////////////// SUBSET 1 ///////////////////////////////////

// Check whether the file meets the criteria to be encrypted.
bool is_encryptable(char *filename) {
    struct stat st;
    if (stat(filename, &st) != 0) {
        printf("%s",  MSG_ERROR_FILE_STAT);
        return 0;
    }
    // check file is regular or not
    if (!S_ISREG(st.st_mode)) {
        printf("%s", MSG_ERROR_DIRECTORY);
        return 0;
    }
    // permissions check
    if (!(st.st_mode & S_IRGRP)) {
        printf("%s", MSG_ERROR_READ);
        return 0;
    }

    char path[MAX_PATH_LEN];
    char *temp = strrchr(filename, '/');
    if (temp != NULL) {
        size_t len = temp - filename;
        if (len >= sizeof(path)) len = sizeof(path) - 1;
        strncpy(path, filename, len);
        path[len] = '\0';
    } else {
        strcpy(path, ".");
    }
    if (stat(path, &st) != 0) {
        printf("%s", MSG_ERROR_FILE_STAT);
        return 0;
    }
    if (!(st.st_mode & S_IWGRP)) {
        printf("%s", MSG_ERROR_WRITE);
        return 0;
    }
    return 1;
}

// XOR the contents of the given file with a set key, and write the result to
// a new file.
void xor_file_contents(char *src_filename, char *dest_filename) {
    FILE *input  = fopen(src_filename, "r");
    FILE *output = fopen(dest_filename, "w");
    int ch;
    while ((ch = fgetc(input)) != EOF) {
        fputc((unsigned char)ch ^ 0xC7, output);
    }
    fclose(input);
    fclose(output);
}


/////////////////////////////////// SUBSET 2 ///////////////////////////////////

// Search the current directory and its subdirectories for filenames containing
// the search string.

void search_by_filename(char *search_string) {
    if (strcmp(search_string, ".") == 0 || strcmp(search_string, "..") == 0) {
        printf("%s", MSG_ERROR_RESERVED);
        return;
    }

    char *results[MAX_LISTINGS];
    int result_count = 0;

    search_file_recusion(".", search_string, results, &result_count);

    sort_strings(results, result_count);
    printf("Found in %d filenames.\n", result_count);

    for (int i = 0; i < result_count; i++) {
        struct stat st;
        stat(results[i], &st);
        char perm[11];
        format_permissions(st.st_mode, perm);
        printf("%s\t%s\n", perm, results[i]);
        free(results[i]);
    }
}

// Search the current directory and its subdirectories for files containing the
// provided search bytes.


void search_by_content(char *search_bytes, int size) {
    content_result *results[MAX_LISTINGS];
    int result_count = 0;
    search_content_recusion(".", search_bytes,
                          size, results, &result_count);

    sort_content_results(results, result_count);

    printf("Found in %d %s.\n", result_count,
           result_count == 1 ? "file" : "files");

    for (int i = 0; i < result_count; i++) {
        printf("%d: %s\n", results[i]->matches, results[i]->filename);
        free(results[i]->filename);
        free(results[i]);
    }
}
/////////////////////////////////// SUBSET 3 ///////////////////////////////////

char *shift_encrypt(char *plaintext, char password[CIPHER_BLOCK_SIZE]) {
    // TODO: complete me
    // shift left cycle
    char *ciphertext = malloc(CIPHER_BLOCK_SIZE);
    for(int i = 0; i < CIPHER_BLOCK_SIZE; i++) {
        int shift = (unsigned char)password[i] % 8;
        unsigned char byte = plaintext[i];
        ciphertext[i] = (byte << shift) | (byte >> (8 - shift));
    }
    return ciphertext;
}

char *shift_decrypt(char *ciphertext, char password[CIPHER_BLOCK_SIZE]) {
    // TODO: complete me
    // shift right cycle
    char *plaintext = malloc(CIPHER_BLOCK_SIZE);
    for(int i = 0; i < CIPHER_BLOCK_SIZE; i++) {
        int shift = (unsigned char)password[i] % 8;
        unsigned char byte = ciphertext[i];
        plaintext[i] = (byte >> shift) | (byte << (8 - shift));

    }
    return plaintext;
}

void ecb_encryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    FILE *input = fopen(filename,"rb");
    if(input == NULL) {
        return;
    }
    //create file name
    char fileoutname[MAX_PATH_LEN];
    snprintf(fileoutname, MAX_PATH_LEN, "%s.ecb", filename);
    FILE *output = fopen(fileoutname, "wb");
    if(output == NULL) {
        return;
    }
    long file_size = get_file_size(input);
    long pad_size = ((file_size + CIPHER_BLOCK_SIZE - 1) / CIPHER_BLOCK_SIZE)
     * CIPHER_BLOCK_SIZE;
    //read and pad
    uint8_t *buf = calloc(1, pad_size);
    fread(buf, 1, file_size, input);
    // encrypto
    for (long offset = 0; offset < pad_size; offset += CIPHER_BLOCK_SIZE) {
        char *enlock = shift_encrypt((char *)(buf + offset), password);
        fwrite(enlock, 1, CIPHER_BLOCK_SIZE, output);
        free(enlock);
    }

    fclose(input);
    fclose(output);
    free(buf);
}

void ecb_decryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    FILE *input = fopen(filename,"rb");
    if(input == NULL) {
        return;
    }
    long file_size = get_file_size(input);
    long pad_size = ((file_size + CIPHER_BLOCK_SIZE - 1) / CIPHER_BLOCK_SIZE)
     * CIPHER_BLOCK_SIZE;
    //create file name
    char fileoutname[MAX_PATH_LEN];
    snprintf(fileoutname, MAX_PATH_LEN, "%s.dec", filename);
    FILE *output = fopen(fileoutname, "wb");
    if(output == NULL) {
        fclose(input);
        return;
    }
    //read and decrypt
    uint8_t *buf = calloc(1, pad_size);
    fread(buf, 1, file_size, input);
    while (ftell(input) < file_size) {
        char *decrypted = shift_decrypt((char *)(buf + ftell(input)), password);
        fwrite(decrypted, 1, CIPHER_BLOCK_SIZE, output);
        free(decrypted);
    }
    fclose(input);
    fclose(output);
    free(buf);
}

/////////////////////////////////// SUBSET 4 ///////////////////////////////////

void cbc_encryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    printf("TODO: COMPLETE ME");
}

void cbc_decryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    printf("TODO: COMPLETE ME");
}

/////////////////////////////////// PROVIDED ///////////////////////////////////
// Some useful provided functions. Do NOT modify.

// Sort an array of strings in alphabetical order.
// strings:  the array of strings to sort
// count:    the number of strings in the array
// This function is to be provided to students.
void sort_strings(char *strings[], int count) {
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < count; j++) {
            if (strcmp(strings[i], strings[j]) < 0) {
                char *temp = strings[i];
                strings[i] = strings[j];
                strings[j] = temp;
            }
        }
    }
}

// Sort an array of content_result(s) in descending order of matches.
// results:  the array of pointers to content_result(s) to sort
// count:    the number of pointers to content_result(s) in the array
// This function is to be provided to students.
void sort_content_results(content_result *results[], int count) {
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < count; j++) {
            if (results[i]->matches > results[j]->matches) {
                content_result *temp = results[i];
                results[i] = results[j];
                results[j] = temp;
            } else if (results[i]->matches == results[j]->matches) {
                // If the matches are equal, sort alphabetically.
                if (strcmp(results[i]->filename, results[j]->filename) < 0) {
                    content_result *temp = results[i];
                    results[i] = results[j];
                    results[j] = temp;
                }
            }
        }
    }
}

// Generate a random string of length RAND_STR_LEN.
// Requires a seed for the random number generator.
// The same seed will always generate the same string.
// The string contains only lowercase + uppercase letters,
// and digits 0 through 9.
// The string is returned in heap-allocated memory,
// and must be freed by the caller.
char *generate_random_string(int seed) {
    if (seed != 0) {
        srand(seed);
    }
    char *alpha_num_str =
        "abcdefghijklmnopqrstuvwxyz"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "0123456789";

    char *random_str = malloc(RAND_STR_LEN);

    for (int i = 0; i < RAND_STR_LEN; i++) {
        random_str[i] = alpha_num_str[rand() % (strlen(alpha_num_str) - 1)];
    }

    return random_str;
}



/////////////////////////////////// HELPER ///////////////////////////////////
static void format_permissions(mode_t mode, char perm[11]) {
    perm[0] = S_ISDIR(mode) ? 'd' : '-';
    perm[1] = (mode & S_IRUSR) ? 'r' : '-';
    perm[2] = (mode & S_IWUSR) ? 'w' : '-';
    perm[3] = (mode & S_IXUSR) ? 'x' : '-';
    perm[4] = (mode & S_IRGRP) ? 'r' : '-';
    perm[5] = (mode & S_IWGRP) ? 'w' : '-';
    perm[6] = (mode & S_IXGRP) ? 'x' : '-';
    perm[7] = (mode & S_IROTH) ? 'r' : '-';
    perm[8] = (mode & S_IWOTH) ? 'w' : '-';
    perm[9] = (mode & S_IXOTH) ? 'x' : '-';
    perm[10] = '\0';
}

static void search_file_recusion(char *dirpath, char *search_string, char *results[], int *count) {
    DIR *dirp = opendir(dirpath);
    struct dirent *dp;
    while ((dp = readdir(dirp)) != NULL) {
        if (strcmp(dp->d_name, ".") == 0 || strcmp(dp->d_name, "..") == 0)
            continue;
        char directpath[MAX_PATH_LEN];
        if (strcmp(dirpath, ".") == 0) {
            snprintf(directpath, sizeof(directpath), "./%s", dp->d_name);
        } else {
            snprintf(directpath, sizeof(directpath), "%s/%s", dirpath, dp->d_name);
        }

        struct stat st;
        stat(directpath, &st);
        if (strstr(dp->d_name, search_string) != NULL) {
            results[(*count)++] = strdup(directpath);
        }

        if (S_ISDIR(st.st_mode)) {
            search_file_recusion(directpath, search_string, results, count);
        }
    }
    closedir(dirp);
}



static void search_content_recusion(char *dirpath, char *pattern, int patlen,
                                  content_result *results[], int *count) {
    DIR *dirp = opendir(dirpath);
    struct dirent *dp;
    while ((dp = readdir(dirp)) != NULL) {
        if (strcmp(dp->d_name, ".") == 0 || strcmp(dp->d_name, "..") == 0)
            continue;

        char directpath[MAX_PATH_LEN];
        if (strcmp(dirpath, ".") == 0) {
            snprintf(directpath, sizeof(directpath), "./%s", dp->d_name);
        } else {
            snprintf(directpath, sizeof(directpath), "%s/%s", dirpath, dp->d_name);
        }

        struct stat st;
        stat(directpath, &st);
        if (S_ISREG(st.st_mode)) {
            FILE *f = fopen(directpath, "r");
            if (f) {
                char *buf = malloc(patlen);
                size_t len = fread(buf, 1, patlen, f);
                int matches = 0;
                while (len == (size_t)patlen) {
                    if (memcmp(buf, pattern, patlen) == 0) {
                        matches++;
                    }
                    memmove(buf, buf+1, patlen-1);
                    int c = fgetc(f);
                    if (c == EOF) break;
                    buf[patlen-1] = (char)c;
                }
                fclose(f);

                if (matches > 0) {
                    content_result *cr = malloc(sizeof(content_result));
                    cr->filename = strdup(directpath);
                    cr->matches = matches;
                    results[(*count)++] = cr;
                }
            }
        }
        if (S_ISDIR(st.st_mode)) {
            search_content_recusion(directpath,
                                  pattern, patlen,
                                  results, count);
        }
    }
    closedir(dirp);
}

static long get_file_size(FILE *file) {
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);
    return file_size;
}
