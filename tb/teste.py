from Crypto.Cipher import AES
import os

def gerar_vetor_teste(tamanho_chave_bits):
    tamanho_bytes = tamanho_chave_bits // 8
    chave = os.urandom(tamanho_bytes)
    texto_claro = os.urandom(16)  # bloco AES é sempre 128 bits

    cipher = AES.new(chave, AES.MODE_ECB)
    texto_cifrado = cipher.encrypt(texto_claro)

    return chave, texto_claro, texto_cifrado

def para_vhdl(dados, nome_sinal):
    hex_str = dados.hex().upper()
    return f'{nome_sinal} <= x"{hex_str}";'

for tamanho, sel in [(128, "00"), (192, "01"), (256, "10")]:
    chave, pt, ct = gerar_vetor_teste(tamanho)
    print(f"-- AES-{tamanho} (sel = \"{sel}\")")
    print(para_vhdl(chave, "chave"))
    print(para_vhdl(pt, "texto_claro"))
    print(para_vhdl(ct, "texto_cifrado_esperado"))
    print()