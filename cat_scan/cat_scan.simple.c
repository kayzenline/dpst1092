/**
 * Cat Scan
 * cat_scan.c
 * 
 * A game where the player deduces the locations of cats hidden in a box.
 *
 * Prior to translating this program into MIPS assembly, you may wish to make use
 * of the provided `cat_scan.simple.c` file. In it, you can replace complex C
 * constructs such as loops with constructs which will be easier to translate
 * into assembly. To help you check that you haven't altered the behaviour of
 * the game, you can run some automated tests using the command:
 *     1092 autotest cat_scan.simple
 * The simplified C version of this code is not marked.
 */

#include <stdio.h>
#include <stdlib.h>

/////////////////// Constants ///////////////////

#define FALSE 0
#define TRUE  1

#define MIN_BOX_SIZE 4
#define MAX_BOX_SIZE 12
#define MAX_PATHS    (4 * MAX_BOX_SIZE)

#define AREA_PER_CAT          13
#define POINTS_PER_CAT        100
#define POINT_LOSS_BAD_GUESS  25
#define POINT_GAIN_GOOD_GUESS 25

#define CAT_NAME_BUFFER_SIZE  128
#define NUM_OF_CAT_TITLES     18
#define NUM_OF_CAT_SURNAMES   30

#define TURN_LEFT  0
#define TURN_RIGHT 1

#define INTERACTION_ABSORB        0
#define INTERACTION_REFLECT       1
#define INTERACTION_DEFLECT_LEFT  2
#define INTERACTION_DEFLECT_RIGHT 3
#define INTERACTION_NONE          4

#define BALL_INIT -1
#define BALL_STATE_ROLLING 'r'
#define BALL_STATE_STOPPED 's'

#define PATH_ENTRY_NOT_SET -1
#define PATH_EXIT_NOT_SET  -1

#define PATH_STATE_NOT_CHECKED 0
#define PATH_STATE_ABSORBED    1
#define PATH_STATE_REFLECTED   2
#define PATH_STATE_CHECKED     3

#define STATE_PLAYING 0
#define STATE_QUIT    1
#define STATE_WIN     2
#define STATE_LOSE    3


// These constants are only used by the provided functions.
#define CMD_QUIT        'q'
#define CMD_HELP        'h'
#define CMD_AUTOPRINT   'a'
#define CMD_PRINT_GAME  'p'
#define CMD_PRINT_STATS 's'
#define CMD_GUESS       'g'
#define CMD_ROLL        'r'
#define CMD_CHEAT       'c'
#define CMD_DEBUG       'd'
#define RNG_MULTIPLIER 75
#define RNG_INCREMENT  74
#define RNG_MODULUS    65537
#define RNG_MIN_SEED   0
#define RNG_MAX_SEED   (RNG_MODULUS - 2)
#define STR_CORNER_ROW        "         "
#define STR_CORNER_TOP_LEFT   "┌"
#define STR_CORNER_TOP_RIGHT  "┐"
#define STR_CORNER_BOT_LEFT   "└"
#define STR_CORNER_BOT_RIGHT  "┘"
#define STR_BORDER_HORIZONTAL "───"
#define STR_BORDER_VERTICAL   "│"
#define STR_INTERSECT_TOP     "┬"
#define STR_INTERSECT_BOT     "┴"
#define STR_INTERSECT_LEFT    "├"
#define STR_INTERSECT_RIGHT   "┤"
#define STR_INTERSECT_CENTRE  "┼"
#define STR_MARGIN_HORIZONTAL " "
#define STR_MARGIN_VERTICAL   "\n"
#define STR_SPRITE_CAT        "^_^"
#define STR_SPRITE_NOCAT      " X "
#define STR_SPRITE_EMPTY      "   "
#define STR_SPRITE_ABSORBED   " A "
#define STR_SPRITE_REFLECTED  " R "

///////////////////// Types /////////////////////

struct ball_of_string {
    int start;
    int x;
    int y;
    int dx;
    int dy;
    char state;
};

struct ball_path {
    int entry;
    int exit;
    int state;
};

struct box {
    int contains_cat[MAX_BOX_SIZE][MAX_BOX_SIZE];
    int guessed[MAX_BOX_SIZE][MAX_BOX_SIZE];
};

// Note: 'struct game' is only required for Subset 3.
struct game {
    struct ball_of_string *ball;
    struct ball_path *paths;
    struct box *box;
};

//////////////////// Globals ////////////////////

int random_number;
int height;
int width;
int num_cats;
int num_cats_found;
int score;
int cost_per_roll;
int is_cheat_mode;
int is_auto_print;
int game_state;
int guess_x;
int guess_y;

struct ball_of_string ball_of_string;
struct ball_path ball_paths[MAX_PATHS];
struct box box;

// Note: 'game' and 'game_pointer' are only required for Subset 3.
struct game game = {
    .ball  = &ball_of_string,
    .paths = ball_paths,
    .box   = &box,
};
struct game *game_pointer = &game;

char cat_name[CAT_NAME_BUFFER_SIZE];
char *cat_titles[] = {
    "Admiral", "Baron", "Baroness", "Captain", "Chairman", "Count", "Countess",
    "Councillor", "Duchess", "Duke", "Emperor", "Empress", "Lady", "Lord",
    "Master", "Mistress", "Professor", "Sheriff"
};
char *cat_surnames[] = {
    "Biscuit", "Blueberry", "Chonk", "Crumpet", "Fluffernap", "Fuzzington",
    "Loaf", "Macaroon", "Marmalade", "Marshmallow", "Meow", "Mittensworth",
    "Moonclaw", "Nibbleton", "Nightwhisker", "Parmesan", "Peaches", "Pickles",
    "Pudding", "Puddingtail", "Pumpkin", "Purrington", "Snugglemane",
    "Stardancer", "Sugarstripe", "Thunderpaw", "Toebean", "Velvetwhisker",
    "von Milkthief", "Waffles"
};


////////////////// Prototypes ///////////////////

// Subset 0
int  main(void);
void print_welcome(void);

// Subset 1
void game_setup(void);
void prompt_for_int(char *name, int min, int max, int *pointer);
void initialise_ball_of_string(void);
void initialise_ball_paths(void);
void initialise_box(void);
void print_stats(void);

// Subset 2
void game_loop(void);
int  is_cat_at_position(int row, int col);
void do_move_ball_forward(struct ball_of_string *ball);
void do_turn_ball(struct ball_of_string *ball, int turn_direction);
void spawn_cats(int amount_of_cats);

// Subset 3
void guess_cat_location(void);
void handle_ball_movement(struct ball_of_string *ball,
                          struct ball_path paths[MAX_PATHS], int interaction);
void generate_cat_name(char name[CAT_NAME_BUFFER_SIZE]);
void roll_ball_of_string(struct game *Game);

// Provided functions. You don't need to understand how they work. 
// But you might find it useful to look at their implementations.
int  random_in_range(int min, int max);
void update_random_number(void);
void process_command(void);
void print_help(void);
void print_debug_info(void);
void print_smiling_cat(void);
void print_crying_cat(void);
void configure_ball(struct ball_of_string *ball, int num_of_edges);
int  check_ball_interactions(struct ball_of_string *ball);
int  edge_number_from_position(int row, int col);
void print_game(void);
void print_game_row_upper(int row);
void print_game_row_inner(int row);
void print_game_row_lower(int row);
void print_grid_row_edge(int size, char *left, char *inter, char *right);
void print_grid_row_edge_upper(int size);
void print_grid_row_edge_inner(int size);
void print_grid_row_edge_lower(int size);
void print_grid_row_cells(int size, int row, int start_column);
void print_cell_content(int row, int col);
int  is_position_in_box(int row, int col);
int  is_position_an_edge_number(int row, int col);
int  is_position_a_path_result(int row, int col);
void print_edge_number(int number);


////////////////////////////////////////////////////////////////////////////////
// Subset 0
////////////////////////////////////////////////////////////////////////////////

// Entry point of the program.
int main(void) {
    print_welcome();
    game_setup();
    game_loop();

    return 0;
}

// Prints an ASCII-art welcome banner.
void print_welcome(void) {
    printf("===============================================================\n");
    printf("                     Welcome to Cat Scan!\n");
    printf("===============================================================\n");
    printf("┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐\n");
    printf("│  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │\n");
    printf("│ ( o.o ) │  │ ( ^_^ ) │  │ ( -.- ) │  │ ( uwu ) │  │ ( z_z ) │\n");
    printf("│ /     \\ │  │ /     \\ │  │ /     \\ │  │ /     \\ │  │ /     \\ │\n");
    printf("└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘\n");
    printf("===============================================================\n\n");
}

////////////////////////////////////////////////////////////////////////////////
// Subset 1
////////////////////////////////////////////////////////////////////////////////

// Initialises game data.
void game_setup(void) {
    // Prompts the user to enter a seed value for the random number generator. 
    // Entering the same seed on different program runs will produce the same
    // sequence of random numbers, allowing for reproducibility.
    prompt_for_int("a random seed", RNG_MIN_SEED, RNG_MAX_SEED, &random_number);

    // get game dimensions
    prompt_for_int("a height", MIN_BOX_SIZE, MAX_BOX_SIZE, &height);
    prompt_for_int("a width ", MIN_BOX_SIZE, MAX_BOX_SIZE, &width);

    // use the game dimensions to calculate the number of cats
    num_cats = (height * width) / AREA_PER_CAT;
    num_cats_found = 0;

    initialise_ball_of_string();
    initialise_ball_paths();
    initialise_box();

    // initialise other global variables
    score = num_cats * POINTS_PER_CAT;
    cost_per_roll = score / (width + height);
    is_cheat_mode = FALSE;
    is_auto_print = TRUE;
    game_state = STATE_PLAYING;
    guess_x = -1;
    guess_y = -1;
    cat_name[0] = '\0';
}

// Prompts the user for an integer within [min, max].
// Note: this function does not handle non-numeric input e.g. an input of 'a'.
void prompt_for_int(char *prompt, int min, int max, int *pointer) {
    int input;

    // repeatedly prompt until a valid integer within [min,max] is entered
    int is_valid_input = FALSE;
    while (!is_valid_input) {
        printf("Enter %s (from %d to %d): ", prompt, min, max);
        scanf("%d", &input);

        if (input < min || input > max) {
            printf("Bad Input: value should be between %d and %d (inclusive)\n", min, max);
        } else {
            is_valid_input = TRUE;
        }
    }

    *pointer = input;
}

// Set ball_of_string members to default values
void initialise_ball_of_string(void) {
    ball_of_string.start = BALL_INIT;
    ball_of_string.x = BALL_INIT;
    ball_of_string.y = BALL_INIT;
    ball_of_string.dx = BALL_INIT;
    ball_of_string.dy = BALL_INIT;
    ball_of_string.state = BALL_STATE_STOPPED;
}

// Sets all ball path members to default values (i.e. not checked).
void initialise_ball_paths(void) {
    for (int i = 0; i < MAX_PATHS; i++) {
        ball_paths[i].entry = PATH_ENTRY_NOT_SET;
        ball_paths[i].exit = PATH_EXIT_NOT_SET;
        ball_paths[i].state = PATH_STATE_NOT_CHECKED;
    }
}

// Sets all box arrays to FALSE (i.e. no cats, and no guesses).
void initialise_box(void) {
    for (int row = 0; row < MAX_BOX_SIZE; row++) {
        for (int col = 0; col < MAX_BOX_SIZE; col++) {
            box.contains_cat[row][col] = FALSE;
            box.guessed[row][col] = FALSE;
        }
    }
}

// Displays the current score, and remaining number of guesses/rolls/cats.
void print_stats(void) {
    int num_guesses_left = score / POINT_LOSS_BAD_GUESS;
    printf("You have %d points = %d", score, num_guesses_left);
    if (num_guesses_left == 1) {
        printf(" guess / ");
    } else {
        printf(" guesses / ");
    }
    int num_rolls_left = score / cost_per_roll;
    printf("%d roll(s) left, with ", num_rolls_left);
    printf("%d cat(s) remaining.\n", num_cats - num_cats_found);
}

////////////////////////////////////////////////////////////////////////////////
// Subset 2
////////////////////////////////////////////////////////////////////////////////

// Main loop handling commands until the game is won/lost/quit.
void game_loop(void) {
    print_help();

    spawn_cats(num_cats);

    game_state = STATE_PLAYING;
    while (game_state == STATE_PLAYING) {
        process_command();
    }

    if (game_state == STATE_WIN) {
        printf("All cats found.\n");
        print_smiling_cat();
        printf("You win! Final Score: %d\n", score);
    } else if (game_state == STATE_LOSE) {
        print_crying_cat();
        printf("Game Over.\n");
    }
}

// Returns TRUE if a [row][col] is in the box and cats[row][col] is TRUE.
int is_cat_at_position(int row, int col) {
    return is_position_in_box(row, col) && box.contains_cat[row][col];
}

// Move the ball one step forward in its current direction.
void do_move_ball_forward(struct ball_of_string *ball) {
    ball->x += ball->dx;
    ball->y += ball->dy;
}

// Rotates the ball's direction left or right.
void do_turn_ball(struct ball_of_string *ball, int turn_direction) {
    if (turn_direction == TURN_LEFT) {
        int dx = ball->dx;
        ball->dx = ball->dy;
        ball->dy = -dx;
    } else if (turn_direction == TURN_RIGHT) {
        do_turn_ball(ball, TURN_LEFT);
        do_turn_ball(ball, TURN_LEFT);
        do_turn_ball(ball, TURN_LEFT);
    }
}

// Randomly hides an 'amount_of_cats' in the box.
void spawn_cats(int amount_of_cats) {
    for (int i = 0; i < amount_of_cats; i++) {
        int cat_row = random_in_range(0, height - 1);
        int cat_col = random_in_range(0, width - 1);

        // repeatedly generate new cat positions until an empty position is found
        while (box.contains_cat[cat_row][cat_col] == TRUE) {
            cat_row = random_in_range(0, height - 1);
            cat_col = random_in_range(0, width - 1);
        }

        box.contains_cat[cat_row][cat_col] = TRUE;
    }
}

////////////////////////////////////////////////////////////////////////////////
// Subset 3
////////////////////////////////////////////////////////////////////////////////

// Allows the user to guess the location of a cat.
void guess_cat_location(void) {
    int row, col;

    while(TRUE) {
        prompt_for_int("a row edge number", 1, height, &guess_y);
        prompt_for_int("a col edge number", height + 1, height + width, &guess_x);
        row = guess_y - 1;
        col = guess_x - (height + 1);

        // loop until the user selects an unguessed location
        if (box.guessed[row][col] == FALSE) {
            box.guessed[row][col] = TRUE;
            break;
        }
        printf("Bad Input: This location has already been guessed. Try again!\n");
    }

    if (is_auto_print) {
        print_game();
    }

    if (box.contains_cat[row][col]) {
        printf("Good Guess! [+%d points]\n", POINT_GAIN_GOOD_GUESS);
        
        generate_cat_name(cat_name);
        printf("You found \"%s\"\n", cat_name);

        score += POINT_GAIN_GOOD_GUESS;
        num_cats_found++;
        if (num_cats_found == num_cats) {
            game_state = STATE_WIN;
        } else {
            print_stats();
        }
    } else {
        printf("Bad Guess [-%d points]\n", POINT_LOSS_BAD_GUESS);
        
        score -= POINT_LOSS_BAD_GUESS;
        if (score < POINT_LOSS_BAD_GUESS) {
            game_state = STATE_LOSE;
        }
        print_stats();
    }
}

// Moves the ball and updates path data.
void handle_ball_movement(struct ball_of_string *ball,
                          struct ball_path paths[MAX_PATHS], int interaction) {
    struct ball_path *path = &paths[ball->start - 1];

    if (interaction == INTERACTION_ABSORB) {
        path->exit = ball->start;
        path->state = PATH_STATE_ABSORBED;
        ball->state = BALL_STATE_STOPPED;
        return;
    } else if (interaction == INTERACTION_REFLECT) {
        path->exit = ball->start;
        path->state = PATH_STATE_REFLECTED;
        ball->state = BALL_STATE_STOPPED;
        return;
    }

    if (interaction == INTERACTION_DEFLECT_LEFT) {
        do_turn_ball(ball, TURN_LEFT);
    } else if (interaction == INTERACTION_DEFLECT_RIGHT) {
        do_turn_ball(ball, TURN_RIGHT);
    }
    do_move_ball_forward(ball);

    // stop the ball if it exits the box
    if (!is_position_in_box(ball->y, ball->x)) {
        ball->state = BALL_STATE_STOPPED;

        path->exit = edge_number_from_position(ball->y, ball->x);
        path->state = PATH_STATE_CHECKED;

        struct ball_path *reverse_path = &paths[path->exit - 1];
        reverse_path->entry = path->exit;
        reverse_path->exit = path->entry;
        reverse_path->state = PATH_STATE_CHECKED;
    }
}

// Generates a random cat name in the name[] array.
// Note: does not check for buffer overflow.
void generate_cat_name(char name[CAT_NAME_BUFFER_SIZE]) {
    char **q = cat_titles + random_in_range(0, NUM_OF_CAT_TITLES - 1);
    for (int i = 0; (*name++ = *(*q + i++)) != '\0';);

    *(name - 1) = ' ';
    
    char **r = cat_surnames + random_in_range(0, NUM_OF_CAT_SURNAMES - 1);
    for (int i = 0; (*name++ = *(*r + i++)) != '\0';);
}

// Lets the player roll a ball from an edge and tracks its path through the box.
void roll_ball_of_string(struct game *game_ptr) {
    configure_ball(game_ptr->ball, 2 * (width + height));

    game_ptr->paths[game_ptr->ball->start - 1].entry = game_ptr->ball->start;

    // take the ball's first move
    int interaction = check_ball_interactions(game_ptr->ball);
    if (interaction == INTERACTION_DEFLECT_LEFT || interaction == INTERACTION_DEFLECT_RIGHT) {
        // case: deflection on first move is considered a reflection
        interaction = INTERACTION_REFLECT;
    }
    handle_ball_movement(game_ptr->ball, game_ptr->paths, interaction);

    // continue moving the ball until it stops
    while (game_ptr->ball->state == BALL_STATE_ROLLING) {
        interaction = check_ball_interactions(game_ptr->ball);
        handle_ball_movement(game_ptr->ball, game_ptr->paths, interaction);
    }

    if (is_auto_print) {
        print_game();
    }

    printf("Ball entered %d", game_ptr->ball->start);
    if (game_ptr->paths[game_ptr->ball->start - 1].state == PATH_STATE_ABSORBED) {
        printf(" and was ABSORBED\n");
    } else {
        printf(" and exited %d\n", game_ptr->paths[game_ptr->ball->start - 1].exit);
    }
    
    printf("Roll Cost [-%d points]\n", cost_per_roll);
    score -= cost_per_roll;
    if (score < POINT_LOSS_BAD_GUESS) {
        game_state = STATE_LOSE;
    }
    print_stats();
}

////////////////////////////////////////////////////////////////////////////////
// Provided Functions
////////////////////////////////////////////////////////////////////////////////

// Generates a random integer within a specified range [min, max].
int random_in_range(int min, int max) {
    update_random_number();
    return (random_number % (max - min + 1)) + min;
}

// Generates a random integer.
//
// This function implements a linear congruential generator (LCG) to produce
// pseudo-random numbers. The LCG is deterministic and produces a sequence of
// numbers based on the initial seed stored in the global variable
// 'random_number'. It uses a small multiplier and modulus to: avoid undefined
// behavior from signed integer overflow; and avoid using an unsigned int.
//
// For more details about LCGs, see:
// - https://en.wikipedia.org/wiki/Linear_congruential_generator 
//
void update_random_number(void) {
    random_number = (random_number * RNG_MULTIPLIER + RNG_INCREMENT) % RNG_MODULUS;
}

// Reads a command and executes the corresponding action.
void process_command(void) {
    printf("\nEnter Command: ");

    char command;
    scanf(" %c", &command);

    if (command == CMD_HELP) {
        printf("(printing help)\n");
        print_help();
    } else if (command == CMD_AUTOPRINT) {
        printf("(auto-print turned ");
        if (is_auto_print) {
            is_auto_print = FALSE;
            printf("OFF)\n");
        } else {
            is_auto_print = TRUE;
            printf("ON)\n");
        }
    } else if (command == CMD_PRINT_STATS) {
        printf("(printing game stats)\n");
        print_stats();
    } else if (command == CMD_PRINT_GAME) {
        printf("(printing game)\n");
        print_game();
    } else if (command == CMD_GUESS) {
        printf("(guessing cat location)\n");
        guess_cat_location();
    } else if (command == CMD_ROLL) {
        printf("(rolling ball of string from edge)\n");
        roll_ball_of_string(game_pointer);
    } else if (command == CMD_CHEAT) {
        printf("(cheating)\n");
        is_cheat_mode = TRUE;
        print_game();
        is_cheat_mode = FALSE;
    } else if (command == CMD_DEBUG) {
        printf("(printing debug info)");
        print_debug_info();
    } else if (command == CMD_QUIT) {
        printf("(quitting)\n");
        game_state = STATE_QUIT;
    } else {
        printf("(bad command)\n");
        print_help();
    } 
}

// Displays instructions, scoring, and a command list.
void print_help(void) {
    printf("\n===============================================================\n");

    printf("There are %d cats hidden in a %d-by-%d", num_cats, height, width);
    printf(" box. Your goal is to deduce\ntheir locations by rolling balls of ");
    printf("string in from the edges\nand noticing where they exit the grid.\n");

    printf("\nBalls of string interact with cats as follows:\n");
    printf("- Absorbed:         when hitting a cat directly.\n");
    printf("- Deflected 90 degrees:  when passing diagonally near a cat.\n");
    printf("- Reflected:        when aimed between two cats one square apart.\n");
    printf("- Reflected:        when deflected before entering the box.\n");
    printf("- Straight-line:    otherwise (no interaction).\n");

    printf("\nStarting Score: %d", score);

    printf("\n\nPoints/Costs:");
    printf("\n- Correct guess   = +%d", POINT_GAIN_GOOD_GUESS);
    printf(" points\n- Incorrect guess = -%d", POINT_LOSS_BAD_GUESS);
    printf(" points\n- Rolling a ball  = -%d", cost_per_roll);

    printf(" points\n\nAvailable Commands:\n ");
    printf("%c - Print this help message.\n ", CMD_HELP);
    printf("%c - Print the game.\n ", CMD_PRINT_GAME);
    printf("%c - Toggle auto-print ON/OFF.\n ", CMD_AUTOPRINT);
    printf("%c - Guess a cat location.\n ", CMD_GUESS);
    printf("%c - Roll a ball of string.\n ", CMD_ROLL);
    printf("%c - Print game stats.\n ", CMD_PRINT_STATS);
    printf("%c - Cheat (reveal cat positions).\n ", CMD_CHEAT);
    printf("%c - Debug info.\n ", CMD_DEBUG);
    printf("%c - Quit the game.\n", CMD_QUIT);

    printf("\n===============================================================\n");
}

// Dumps the current game state for debugging (excluding the ball_path[] array).
void print_debug_info(void) {
    printf("\n================ DEBUG INFO ================\n");

    printf("random_number  = %d\n", random_number);
    printf("height         = %d\n", height);
    printf("width          = %d\n", width);
    printf("num_cats       = %d\n", num_cats);
    printf("num_cats_found = %d\n", num_cats_found);
    printf("score          = %d\n", score);
    printf("cost_per_roll  = %d\n", cost_per_roll);
    printf("is_cheat_mode  = %d\n", is_cheat_mode);
    printf("game_state     = %d\n", game_state);
    printf("guess_x        = %d\n", guess_x);
    printf("guess_y        = %d\n", guess_y);
    printf("cat_name       = \"%s\"\n", cat_name);

    printf("\n                     ");
    for (int col = 0; col < MAX_BOX_SIZE; col++) {
        printf("%2d", col % 10);
    }
    putchar('\n');
    for (int row = 0; row < MAX_BOX_SIZE; row++) {
        printf("box.contains_cat[%d]: ", row);
        if (row < 10) {
            putchar(' ');
        }
        for (int col = 0; col < MAX_BOX_SIZE; col++) {
            printf("%d ", box.contains_cat[row][col]);
        }
        putchar('\n');
    }

    printf("\n                ");
    for (int col = 0; col < MAX_BOX_SIZE; col++) {
        putchar(' ');
        printf("%d", col % 10);
    }
    putchar('\n');
    for (int row = 0; row < MAX_BOX_SIZE; row++) {
        printf("box.guessed[%d]: ", row);
        if (row < 10) {
            putchar(' ');
        }
        for (int col = 0; col < MAX_BOX_SIZE; col++) {
            printf("%d ", box.guessed[row][col]);
        }
        putchar('\n');
    }

    putchar('\n');
    printf("ball_of_string.start = %d\n", ball_of_string.start);
    printf("ball_of_string.x     = %d\n", ball_of_string.x);
    printf("ball_of_string.y     = %d\n", ball_of_string.y);
    printf("ball_of_string.dx    = %d\n", ball_of_string.dx);
    printf("ball_of_string.dy    = %d\n", ball_of_string.dy);
    printf("ball_of_string.state = %c\n", ball_of_string.state);

    putchar('\n');
    
    for (int i = 0; i < MAX_PATHS; i++) {
        printf("ball_paths[%d]: { entry: %d, exit: %d, state: %d }\n",
               i, ball_paths[i].entry, ball_paths[i].exit, ball_paths[i].state);
    }
}

// Prints an ASCII-art smiling cat.
void print_smiling_cat(void) {
    printf("┌─────────┐\n");
    printf("│  /\\_/\\  │\n");
    printf("│ (*^_^*) │\n");
    printf("│ /     \\ │\n");
    printf("└─────────┘\n");
}

// Prints an ASCII-art crying cat. Miaw miaw miaw miaw.
void print_crying_cat(void) {
    printf("┌─────────┐\n");
    printf("│  /\\_/\\  │\n");
    printf("│ ( T_T ) │\n");
    printf("│ /     \\ │\n");
    printf("└─────────┘\n");
}

// Sets the ball's starting edge, position, direction, and state.
void configure_ball(struct ball_of_string *ball, int number_of_edges) {
    prompt_for_int("an edge number", 1, number_of_edges, &ball->start);

    int edge_number = ball->start;
    if (edge_number <= height) {
        // case: ball enters from an edge on the left side of the box
        ball->x = -1;
        ball->y = edge_number - 1;
        ball->dx = 1;
        ball->dy = 0;
    } else if (edge_number <= height + width) {
        // case: ball enters from an edge on the bottom side of the box
        ball->x = edge_number - 1 - height;
        ball->y = height;
        ball->dx = 0;
        ball->dy = -1;
    } else if (edge_number <= height + width + height) {
        // case: ball enters from an edge on the right side of the box
        ball->x = width;
        ball->y = (height + width + height) - edge_number;
        ball->dx = -1;
        ball->dy = 0;
    } else {
        // case: ball enters from an edge on the top side of the box
        ball->x = (height + width + height + width) - edge_number;
        ball->y = -1;
        ball->dx = 0;
        ball->dy = 1;
    }

    ball->state = BALL_STATE_ROLLING;
}

// Simulates ball movements. Returns what interaction would occur with any cat(s).
int check_ball_interactions(struct ball_of_string *ball) {
    // check if position directly ahead contains a cat
    do_move_ball_forward(ball);
    int cat_ahead = is_cat_at_position(ball->y, ball->x);

    // check if position ahead to the left contains a cat
    do_turn_ball(ball, TURN_LEFT);
    do_move_ball_forward(ball);
    int cat_to_left = is_cat_at_position(ball->y, ball->x);

    // check if position ahead to the right contains a cat
    do_turn_ball(ball, TURN_LEFT);
    do_turn_ball(ball, TURN_LEFT);
    do_move_ball_forward(ball);
    do_move_ball_forward(ball);
    int cat_to_right = is_cat_at_position(ball->y, ball->x);

    // return the ball to its original position and heading
    do_turn_ball(ball, TURN_RIGHT);
    do_move_ball_forward(ball);
    do_turn_ball(ball, TURN_RIGHT);
    do_move_ball_forward(ball);
    do_turn_ball(ball, TURN_RIGHT);

    if (!cat_ahead) {
        if (cat_to_left && cat_to_right) {
            return INTERACTION_REFLECT;
        } else if (cat_to_left) {
            return INTERACTION_DEFLECT_RIGHT;
        } else if (cat_to_right) {
            return INTERACTION_DEFLECT_LEFT;
        }
        return INTERACTION_NONE;
    } else {
        return INTERACTION_ABSORB;
    }
}

// Maps a row/col outside the box to an edge number.
int edge_number_from_position(int row, int col) {
    if (col < 0 && 0 <= row && row < height) {
        // case: edge is on left side
        return 1 + row;
    } else if (row >= height && 0 <= col && col < width) {
        // case: edge is on bottom side
        return 1 + height + col;
    } else if (col >= width && 0 <= row && row < height) {
        // case: edge is on right side
        return height + width + (height - row);
    } else if (row < 0 && 0 <= col && col < width) {
        // case: edge is on top side
        return height + width + height + (width - col);
    } else {
        // case: not an edge position
        printf("Fatal Error: edge_number_from_position(): position not on edge\n");
        exit(EXIT_FAILURE);
    }
}

// Renders the game.
void print_game(void) {
    for (int row = -2; row < height + 2; row++) {
        print_game_row_upper(row);
        print_game_row_inner(row);
        print_game_row_lower(row);
    }
}

// Prints the upper border of a game row.
void print_game_row_upper(int row) {
    if (row == -2 || row == -1 || row == height + 1) {
        printf(STR_CORNER_ROW);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_upper(width);
    } else if (row == 0) {
        print_grid_row_edge_upper(1);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge(width + 2, STR_CORNER_TOP_LEFT, STR_INTERSECT_CENTRE, STR_CORNER_TOP_RIGHT);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_upper(1);
    } else if (row == height) {
        print_grid_row_edge_lower(1);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge(width + 2, STR_CORNER_BOT_LEFT, STR_INTERSECT_CENTRE, STR_CORNER_BOT_RIGHT);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_lower(1);
    } else {
        print_grid_row_edge_inner(1);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_inner(width + 2);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_inner(1);
    }

    putchar('\n');
}

// Prints the inner content of a game row.
void print_game_row_inner(int row) {
    if (row  < 0 || row >= height) {
        // print two top rows, and two bottom rows
        printf(STR_CORNER_ROW);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_cells(width, row, 0);
    } else {
        // print middle rows
        print_grid_row_cells(1, row, -2);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_cells(width + 2, row, -1);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_cells(1, row, width + 1);
    } 

    putchar('\n');
}

// Prints the lower border of a game row.
void print_game_row_lower(int row) {
    if (row == -2 || row == height || row == height + 1) {
        printf(STR_CORNER_ROW);
        printf(STR_MARGIN_HORIZONTAL);
        print_grid_row_edge_lower(width);
        printf(STR_MARGIN_VERTICAL);
    } 
}

// Helper to print the edge of a grid of width 'size'.
void print_grid_row_edge(int size, char *left, char *inter, char *right) {
    printf("%s", left);
    for (int col = 0; col < size - 1; col++) {
        printf(STR_BORDER_HORIZONTAL);
        printf("%s", inter);
    }
    printf(STR_BORDER_HORIZONTAL);
    printf("%s", right);
}

// Prints an upper edge of a grid of width 'size'.
void print_grid_row_edge_upper(int size) {
    print_grid_row_edge(size, STR_CORNER_TOP_LEFT, STR_INTERSECT_TOP, STR_CORNER_TOP_RIGHT);
}

// Prints an internal edge of a grid of width 'size'.
void print_grid_row_edge_inner(int size) {
    print_grid_row_edge(size, STR_INTERSECT_LEFT, STR_INTERSECT_CENTRE, STR_INTERSECT_RIGHT);
}

// Prints a lower edge of a grid of width 'size'.
void print_grid_row_edge_lower(int size) {
    print_grid_row_edge(size, STR_CORNER_BOT_LEFT, STR_INTERSECT_BOT, STR_CORNER_BOT_RIGHT);
}

// Prints a row of cells within a grid, assuming the grid begins at start_column.
void print_grid_row_cells(int size, int row, int start_column) {
    printf(STR_BORDER_VERTICAL);
    for (int col = start_column; col < size + start_column; col++) {
        print_cell_content(row, col);
        printf(STR_BORDER_VERTICAL);
    }
}

// Prints the content of a single cell within the printed game.
void print_cell_content(int row, int col) {
    if (is_position_an_edge_number(row, col)) {
        int edge_number = edge_number_from_position(row, col);
        print_edge_number(edge_number);
    } else if (is_position_in_box(row, col) && box.guessed[row][col]) {
        if (box.contains_cat[row][col]) {
            printf(STR_SPRITE_CAT);
        } else {
            printf(STR_SPRITE_NOCAT);
        }
    } else if (is_position_in_box(row, col) && is_cheat_mode) {
        if (box.contains_cat[row][col]) {
            printf(STR_SPRITE_CAT);
        } else {
            printf(STR_SPRITE_EMPTY);
        }
    } else if (is_position_a_path_result(row, col)) {
        int edge_number = edge_number_from_position(row, col);
        struct ball_path path = ball_paths[edge_number - 1];

        if (path.state == PATH_STATE_NOT_CHECKED) {
            printf(STR_SPRITE_EMPTY);
        } else if (path.state == PATH_STATE_ABSORBED) {
            printf(STR_SPRITE_ABSORBED);
        } else if (path.state == PATH_STATE_REFLECTED) {
            printf(STR_SPRITE_REFLECTED);
        } else if (path.state == PATH_STATE_CHECKED) {
            print_edge_number(path.exit);
        }
    } else {
        printf(STR_SPRITE_EMPTY);
    }
}

// Returns true if row/col refers to a cell/location within the box.
int is_position_in_box(int row, int col) {
    return (
        0 <= row && row < height &&
        0 <= col && col < width
    );
}

// Returns TRUE if row/col refers to an edge number cell on the printed board.
int is_position_an_edge_number(int row, int col) {
    int col_in_range = (col >= 0 && col < width);
    int row_in_range = (row >= 0 && row < height);

    int is_edge_row = (row == -1 || row == height);
    int is_edge_col = (col == -1 || col == width);

    return ((col_in_range && is_edge_row) || (row_in_range && is_edge_col));
}

// Returns TRUE if row/col refers to a path result cell on the printed board.
int is_position_a_path_result(int row, int col) {
    int col_in_range = (col >= 0 && col < width);
    int row_in_range = (row >= 0 && row < height);

    int is_path_row = (row == -2 || row == height + 1);
    int is_path_col = (col == -2 || col == width + 1);

    return ((col_in_range && is_path_row) || (row_in_range && is_path_col));
}

// Formats and prints an edge number. Handles up to 3-digits. 
void print_edge_number(int number) {
    if (number < 10) {
        printf(" %d ", number);
    } else if (number < 100) {
        printf(" %d", number);
    } else {
        printf("%d", number);
    }
}