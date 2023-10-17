# Вариант 14
.include "macros.asm"
.data
array: .space 40
arrayB: .space 40

incorrect_size_info: .asciz "Incorrect size!\nMust be between 1 and 10!\n"
prompt: .asciz  "Enter an array element: "


.text
		
	li a7, 5
	ecall	# Считали инт - размер массива
	
	mv t6, a0  # Сохранили в "переменную" s0
	# Вызовем функцию проверки на корретность размера массива
	# Но перед этим положим переменную на стек
	addi sp, sp, -4
	sw  a0, (sp)
	jal check_limits
	addi sp sp 4 # "Почистили" то, что положили
	# Проверим, что вернула функция
	li a1, 1
	beq a0, a1, .correct_main_size
	# Если попали сюда - значит размер не удовлетворяет нужному
	la a0, incorrect_size_info
	li a7 4
	ecall
	j .end_main # Завершаем работу программы
	
	.correct_main_size:
	# Если попали сюда - значит все четко, считывает массив
	mv a0, t6
	jal input_array
	
	.end_main:
	li a0, 0
	li a7, 10
	ecall



.text
check_limits:
	# Функция проверяет, входит ли переданное число в границы от 1 до 10 включительно
	# Если удовлетворяет условию, возвращает 1(true), иначе 0(false). Значение кладется в a0
	addi sp, sp, -4
	sw  ra, (sp)
	
	# Считаем данные со стека
	addi a0, sp, 4
	lw a1, (a0)  # Загрузили наше число
	li a0, 1 # bool res = true
	
	li a2, 1
	blt a1, a2, .incorrect_check_size
	
	li a2, 11
	bge a1, a2, .incorrect_check_size
	
	j .end_check
	
	.incorrect_check_size:
	li a0, 0
	
	.end_check:
	lw ra (sp)    # восстановим текущий ra
	addi sp sp 4  # из стека
	ret


.text
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
        
    # На этом этапе t3 содержит максимальное значение
     la  t1, array      # Загрузить адрес array в t1 для чтения
    la  t4, arrayB     # Загрузить адрес arrayB в t4 для записи

    li  t2, 0          # Счетчик

    process_loop:
        lw  a0, (t1)   # Загрузить текущий элемент из array

        blt  a0, zero, replace_with_max
        sw  a0, (t4)   # Если элемент положительный или равен нулю, сохранить в arrayB
        j    skip_replacement

    replace_with_max:
        sw  t3, (t4)   # Заменить отрицательное число максимальным значением

    skip_replacement:
        addi t1, t1, 4
        addi t4, t4, 4
        
        addi t2, t2, 1
        blt  t2, t0, process_loop   # Повторять, пока не обработаны все элементы

    # Теперь выведем массив B
    la  t1, arrayB
    li  t2, 0

    output_loop:
        li  a7, 1
        lw  a0, (t1)
        ecall		
        newline			#макрос
        newline			#макрос
        addi t1, t1, 4
        addi t2, t2, 1

        blt  t2, t0, output_loop

    # Восстановление ra и завершение функции
    lw  ra, (sp)
    addi sp, sp, 4
    ret


	

