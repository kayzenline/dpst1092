#include <stdio.h>
#include <stdint.h>

int main() {
    uint32_t a, b;
    
    // 从键盘读入两个十进制整数（你可以直接输入 1481199189 -2023406815）
    scanf("%u", &a);
    scanf("%u", &b);

    // 拆分 a 为字节
    unsigned char a_bytes[4] = {
        a & 0xFF,
        (a >> 8) & 0xFF,
        (a >> 16) & 0xFF,
        (a >> 24) & 0xFF
    };

    // 对照 "UNIX" 确定字节顺序
    char correct[4] = {'U', 'N', 'I', 'X'};
    int order[4];

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if (a_bytes[i] == correct[j]) {
                order[j] = i;
                break;
            }
        }
    }

    // 拆分 b
    unsigned char b_bytes[4] = {
        b & 0xFF,
        (b >> 8) & 0xFF,
        (b >> 16) & 0xFF,
        (b >> 24) & 0xFF
    };

    // 重组 b 的字节
    uint32_t result = 0;
    for (int i = 0; i < 4; i++) {
        result |= ((uint32_t)b_bytes[order[i]] << (8 * i));
    }

    // 打印结果（signed）
    printf("%d\n", (int32_t)result);

    return 0;
}
