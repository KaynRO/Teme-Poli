// skel PA 2017

#include <iostream>
#include <vector>

#include "reversi.h"

int direX[] = {-1, -1, -1, 1, 1, 1, 0, 0} ;
int direY[] = {-1, 0, 1, -1, 0, 1, 1, -1} ;

inline int abs(int x)
{
    return x > 0 ? x : -x;
}

Move::Move(int player, int x = -1, int y = -1): player(player), x(x), y(y)
{
}

Reversi::Reversi()
{
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            data[i][j] = 0;
    data[N / 2 - 1][N / 2 - 1] = data[N / 2][N / 2] = 1;
    data[N / 2 - 1][N / 2] = data[N / 2][N / 2 - 1] = -1;
}


/**
 * Intoarce true daca jocul este intr-o stare finala
 */
    bool
Reversi::ended()
{
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
        {
            Reversi tmp(*this);
            if (tmp.apply_move(Move(1, i, j)))
                return false;
            tmp = *this;
            if (tmp.apply_move(Move(-1, i, j)))
                return false;
        }
    return true;
}

/**
 * Returns 1 if player won, 0 if draw and -1 if lost
 */
int
Reversi::winner(int player)
{
    if (!ended())
        return 0;
    int s = 0;
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
        {
            if (data[i][j] == player)
                s++;
            else if (data[i][j] == -player)
                s--;
        }
    return s > 0 ? 1 : s == 0 ? 0 : -1;
}

/**
 * Functia de evaluare a starii curente a jocului
 * Evaluarea se face din perspectiva jucatorului
 * aflat curent la mutare (player)
 */
    int
Reversi::eval(int player)
{
    /**
     * TODO Implementati o functie de evaluare
     * Aceasta trebuie sa intoarca:
     * Inf daca jocul este terminat in favoarea lui player
     * -Inf daca jocul este terminat in defavoarea lui player
     *
     * In celelalte cazuri ar trebui sa intoarca un scor cu atat
     * mai mare, cu cat player ar avea o sansa mai mare de castig
     */

    if(ended() && winner(1) == 1)
        return Inf ;
    if(ended() && winner(-1) == 1)
        return -Inf ;

    int total = 0 ;
    for(int i = 0 ; i < N ; i++)
        for(int j = 0 ; j < N ; j++)
            if(data[i][j] == player)
                total++ ;
            else if(data[i][j] == -player)
                total-- ;

    return total ;
}

/**
 * Aplica o mutare a jucatorului, modificand starea jocului
 * Plaseaza piesa jucatorului move.player in pozitia move.x, move.y
 * Mutarea move.x == -1, move.y == -1 semnifica ca jucatorul
 * paseaza randul la mutare
 * Returneaza true daca mutarea este valida
 */
    bool
Reversi::apply_move(const Move &move)
{
    if (move.x == -1 && move.y == -1)
        return true;

    if (data[move.x][move.y] != 0)
        return false;

    bool ok = false;

    for (int x_dir = -1; x_dir <= 1; x_dir++)
        for (int y_dir = -1; y_dir <= 1; y_dir++)
        {
            if (x_dir == 0 && y_dir == 0)
                continue;
            int i = move.x + x_dir, j = move.y + y_dir;
            for (; i >= 0 && j >= 0 && i < N && j < N && data[i][j] == -move.player; i += x_dir, j += y_dir);
            if (i >= 0 && j >= 0 && i < N && j < N && data[i][j] == move.player && (abs(move.x - i) > 1 || abs(move.y - j) > 1))
            {
                ok = true;
                for (i = move.x + x_dir, j = move.y + y_dir; i >= 0 && j >= 0 && i < N && j < N && data[i][j] == -move.player; i += x_dir, j += y_dir)
                    data[i][j] = move.player;
            }
        }

    if (!ok)
        return false;

    data[move.x][move.y] = move.player;

    return true;
}

void Reversi::undo_move(const Move &move){
    data[move.x][move.y] = 0 ;
}

/**
 * Afiseaza starea jocului
 */
    void
Reversi::print()
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j< N; j++)
        {
            if (data[i][j] == 0)
                std::cout << '.';
            else if (data[i][j] == 1)
                std::cout << 'O';
            else
                std::cout << 'X';
            std::cout << " ";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

std::vector<Move> Reversi::get_moves(int player){
    std::vector<Move> moves ;
    for(int i = 0 ; i < N ; i++)
        for(int j = 0 ; j < N ; j++)
            for(int k = 0 ; k < 8 ; k++)
                    if(data[i][j] == player && data[i + direX[k]][j + direY[k]] == 0
                       && i + direX[k] >= 0 && i + direX[k] < N 
                       && j + direY[k] >= 0 && j + direY[k] < N)
                        moves.push_back(Move(player,i + direX[k], j + direY[k])) ;

    return moves ;
}


/**
 * Implementarea algoritmului minimax (negamax)
 * Intoarce o pereche <x, y> unde x este cel mai bun scor
 * care poate fi obtinut de jucatorul aflat la mutare,
 * iar y este mutarea propriu-zisa
 */
    std::pair<int, Move>
minimax(Reversi init, int player, int depth)
{
    /**
     * TODO Implementati conditia de oprire
     */

    if(depth == 0 || init.ended())
        return std::pair<int, Move>(init.eval(player), Move(player)) ;

    std::vector<Move> moves = init.get_moves(player) ;
    if(moves.size() == 0)
        moves.push_back(Move(player)) ;

    for(Move move:moves)
        std::cout << move.x << ' ' << move.y << '\n' ;

    int max = -Inf - 1 ;
    Move bMove = Move(player) ;
    for(Move move : moves){
        if(init.apply_move(move)){
            int score = -minimax(init, -player, depth - 1).first ;

            if(score > max){
                max = score ;
                bMove = move ;
            }
        }
        init.undo_move(move) ;
    }

    /**
     * TODO Determinati mutarile posibile
     * si determinati cel mai bun scor si cea mai buna mutare
     * folosind algoritmul minimax
     *
     * Fiti atenti ca daca player nu poate efectua nici o mutare, el
     * poate ceda randul la mutat prin mutarea conventionala <player, -1, -1>
     */

    return std::pair<int, Move>(max, bMove);
}

/**
 * Implementarea de negamax cu alpha-beta pruning
 * Intoarce o pereche <x, y> unde x este cel mai bun scor
 * care poate fi obtinut de jucatorul aflat la mutare,
 * iar y este mutarea propriu-zisa
 */
    std::pair<int, Move>
minimax_abeta(Reversi init, int player, int depth, int alfa, int beta)
{
    /* Conditia de oprire */
    if (depth == 0 || init.ended())
        return std::pair<int, Move>(init.eval(player), Move(player));

    /**
     * TODO Determinati mutarile posibile
     * si determinati cel mai bun scor si cea mai buna mutare
     * folosind algoritmul minimax cu alfa-beta pruning
     *
     * Fiti atenti ca daca player nu poate efectua nici o mutare, el
     * poate ceda randul la mutat prin mutarea conventionala <player, -1, -1>
     */

    std::pair<int, Move> ret = std::pair<int, Move>(-Inf, Move(player));

    return ret;
}

int main()
{
    Reversi rev;
    rev.print();

    /* Choose here if you want COMP vs HUMAN or COMP vs COMP */
    bool HUMAN_PLAYER = false;
    int player = 1;

    while (!rev.ended())
    {
        std::pair<int, Move> p(0, Move(player));
        if (player == 1)
        {
            p = minimax(rev, player, 6);
            //p = minimax_abeta(rev, player, 9, -Inf, Inf);

            std::cout << "Player " << player << " evaluates to " << p.first << std::endl;
            rev.apply_move(p.second);
        }
        else
        {
            if (!HUMAN_PLAYER)
            {
                p = minimax(rev, player, 6);
                //p = minimax_abeta(rev, player, 9, -Inf, Inf);

                std::cout << "Player " << player << " evaluates to " << p.first << std::endl;
                rev.apply_move(p.second);
            }
            else
            {
                bool valid = false;
                while (!valid)
                {
                    int x, y;
                    std::cout << "Insert position [0..N - 1], [0..N - 1] ";
                    std::cin >> x >> y;
                    valid = rev.apply_move(Move(player, x, y));
                }
            }
        }

        rev.print();
        player *= -1;
    }

    int w = rev.winner(1);
    if (w == 1)
        std::cout << "Player 1 WON!" << std::endl;
    else if (w == 0)
        std::cout << "Draw" << std::endl;
    else
        std::cout << "Player -1 WON!" << std::endl;
}