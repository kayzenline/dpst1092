Russian = """\
россия, москва, 119415
пр.Вернадского, 37,
к.1817-1,
жлетневой светлане
"""

print("with koi8_r encoding:")
print(Russian)

RussianBytes = Russian.encode('koi8_r')

print("raw bytes:")
for byte in RussianBytes.splitlines():
    print(byte)
print()


French = """\
ÒÏÓÓÉÑ, ÍÏÓË×Á, 119415
ÐÒ.÷ÅÒÎÁÄÓËÏÇÏ, 37,
Ë.1817-1,
ÖÌÅÔÎÅ×ÏÊ Ó×ÅÔÌÁÎÅ
"""

print("with latin-1 encoding:")
print(French)

FrenchBytes = French.encode('latin-1')

print("raw bytes:")
for byte in FrenchBytes.splitlines():
    print(byte)
print()

print(f"{(RussianBytes == FrenchBytes) = }")