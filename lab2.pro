% Лаб.2 | Шаповалова Д.Д. | НПИбд-02-21

implement main
    open core, file, stdio

domains
    category = ноутбуки; планшеты; смартфоны; чехлы.

class facts - shop
    товар : (string Название_товара, category Категория, integer Цена).
    клиент : (string Имя_клиента, string Номер_телефона).
    покупка : (string Номер_телефона, string Название_товара, integer Колво_товара, string Дата).

class facts
    s : (real Sum) single.

clauses
    s(0).

class predicates
    кто_купил : (string Id_товара) nondeterm.
    товары : (category Категория) nondeterm.
    продано_когда : (string Дата) nondeterm.
    покупал_клиент : (string Имя_клиента) nondeterm.
    выручка_в_опред_день : (string Дата) nondeterm.

clauses
    %Правило. Кто купил данный товар
    кто_купил(X) :-
        покупка(A, X, _, _),
        клиент(B, A),
        write("Данный товар купил: ", B),
        nl,
        fail.
    кто_купил(X) :-
        покупка(_, X, _, _),
        write("\n"),
        nl,
        fail.

    %Правило. Вывод товаров категории который вводит пользователь
    товары(X) :-
        товар(Y, X, S),
        write(Y, ", его цена: ", S, " рублей."),
        nl,
        fail.
    товары(X) :-
        товар(_, X, _),
        write("\n"),
        nl,
        fail.

    %Правило. Список товаров проданных в определенный день
    продано_когда(X) :-
        покупка(_, Y, _, X),
        товар(Y, _, _),
        write(X, ": продано ", Y),
        nl,
        fail.
    продано_когда(X) :-
        покупка(_, _, _, X),
        write("\n"),
        nl,
        fail.

    %Правило. Покупал ли что клиент?
    покупал_клиент(X) :-
        клиент(X, Y),
        покупка(Y, _, _, _),
        write("Да, данный клиент совершал у нас покупку\n"),
        nl,
        fail.
    покупал_клиент(X) :-
        покупка(_, _, _, X),
        write("\n"),
        nl,
        fail.

    %Правило. Сколько выручки в опреденный день?
    выручка_в_опред_день(X) :-
        покупка(_, Y, B, X),
        товар(Y, _, A),
        s(Sum),
        С = A * B,
        assert(s(Sum + С)),
        fail.
    выручка_в_опред_день(X) :-
        покупка(_, _, _, X),
        s(Sum),
        write("Выручка за день составила ", Sum, " рублей.\n"),
        nl,
        fail.
    выручка_в_опред_день(X) :-
        покупка(_, _, _, X),
        write("\n"),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("..\\data.txt", shop),
        write("Правило: Кто купил данный товар\n"),
        кто_купил("Смартфон Apple iPhone 14 Pro"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\data.txt", shop),
        write("Правило: Вывод товаров определенной категории\n"),
        товары(смартфоны),
        fail.

    run() :-
        console::init(),
        reconsult("..\\data.txt", shop),
        write("Правило: Список товаров проданных в определенный день\n"),
        продано_когда("03.03.2023"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\data.txt", shop),
        write("Правило: Покупал ли что данный клиент?\n"),
        покупал_клиент("Алексей"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\data.txt", shop),
        write("Правило: Сколько выручки в опреденный день\n"),
        выручка_в_опред_день("03.03.2023"),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).
