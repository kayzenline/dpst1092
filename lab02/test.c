#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define N_BITS 16

// 打印 16 位二进制
void print_binary(int16_t value) {
    for (int i = N_BITS - 1; i >= 0; i--) {
        printf("%d", (value >> i) & 1);
    }
}

// 核心函数：将 16 位二进制字符串转换为有符号整数
int16_t sixteen_in(char *input) {
    int16_t result = 0;

    printf("构造过程（每一步）:\n");
    for (int i = 0; i < N_BITS; i++) {
        result <<= 1;
        printf("步骤 %2d：输入位 = %c → 左移后: ", i, input[i]);
        print_binary(result);

        if (input[i] == '1') {
            result |= 1;
            printf(" → 设置末位1后: ");
            print_binary(result);
        }

        printf("  → 十进制: %d\n", result);
    }

    printf("\n最终十进制结果: %d\n", result);
    return result;
}

// 主函数：从命令行读取输入字符串
int main(void) {
    char input[N_BITS + 1];

    printf("请输入 16 位二进制字符串: ");
    scanf("%16s", input);

    // 简单长度验证（可选）
    if (strlen(input) != N_BITS) {
        printf("错误：必须输入 16 位二进制字符串。\n");
        return 1;
    }

    sixteen_in(input);
    return 0;
}
