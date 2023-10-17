#
# Example library of macros.
#

# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

.macro print_imm_int (%x)
    li a7, 1
    li a0, %x
    ecall
.end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

# Ввод целого числа с консоли в указанный регистр,
# исключая регистр a0
.macro read_int(%x)
   push	(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

   .macro print_str (%x)
   .data
str:
   .asciz %x
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
   .end_macro

   .macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
   .end_macro

   .macro newline
   print_char('\n')
   .end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

.macro array_Filler
input_array:
    addi sp, sp, -4
    sw  ra, (sp)
    mv  t0, a0
    la  t1, array

    # Инициализация t2 (счетчика) и t3 (текущего максимального значения)
    li  t2, 0
    li  t3, -2147483648   # Инициализируем минимальным значением для int

    input_loop:
        # Вводим элемент
        la  a0, prompt
        li  a7, 4
        ecall
        li  a7, 5
        ecall
        
        # Сравниваем текущий элемент с максимальным значением
        blt  a0, t3, not_max
        mv  t3, a0           # Если текущий элемент больше, обновляем максимальное значение

    not_max:
        # Сохраняем введенный элемент в массиве
        sw a0, (t1)
        addi t1, t1, 4
        
        addi t2, t2, 1
        blt t2, t0, input_loop   # Если еще не ввели все элементы, повторяем цикл
.end_macro