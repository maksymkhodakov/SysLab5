# Ходаков Максим ТТП-32
### Лабораторна робота № 5 з Системного програмування

#### Послідовність команд, щоб запустити проєкт:  
    lex lexer.l
    yacc -d -v parser.y
    gcc -ll -w y.tab.c
    ./a.out<назва_файлу.c