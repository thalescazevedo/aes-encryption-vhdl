# =========================================================================
# Script de automação do Testbench no ModelSim
# =========================================================================

# Encerra qualquer simulação rodando
quit -sim

# Cria a biblioteca (ignora o erro se ela já existir)
vlib work

# Compila os pacotes e componentes na ordem correta
vcom -2008 src/Commons/roms_package.vhdl
vcom -2008 src/AES_PACK.vhdl
vcom -2008 src/AES_Components/keySchedule.vhdl

# Compila o testbench
vcom -2008 tb/tb1.vhdl

# Inicia a simulação do testbench na work
vsim work.tb1

# Configura as formas de onda para ter o tempo limpo e em HEX
view wave
delete wave *

# Formato e organização limpos na visualização
add wave -noupdate -divider "Controles do UUT"
add wave -noupdate -color {Orange} -label "Round Actual" -radix unsigned /tb1/s_round_counter
add wave -noupdate -color {Yellow} -label "AES Type" /tb1/s_aes_type

add wave -noupdate -divider "Constantes de Entrada"
add wave -noupdate -label "User Key Completa" -radix hex /tb1/s_last_round_key

add wave -noupdate -divider "Saida Computada"
add wave -noupdate -color {Green} -label "Round Key Result (128-bit)" -radix hex /tb1/s_out_128bits

TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {100 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 350
configure wave -justifyvalue left

# Roda
run 80 ns
