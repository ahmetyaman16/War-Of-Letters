
# Haskell Board Game – A_B_C vs Z

A simple educational Haskell project featuring a two-player board game on a 3x5 grid. Team A-B-C tries to trap player Z, who attempts to escape past them. The project demonstrates functional programming principles such as recursion, immutability, list operations, and user input handling.

---

## 🧠 Project Purpose

This project was developed as part of the **Principles of Programming Languages** course (CSE2260). Its main goal is to teach fundamental Haskell concepts through interactive and rule-based gameplay.

---

## 🎮 Game Rules

- A, B, and C form a team to block Z.
- Z wins if it moves to a column **left of all** other letters.
- A, B, and C win if Z is **completely trapped**.
- The game ends in a draw if the maximum number of moves is reached.
- A, B, and C **cannot move backward** horizontally.

---

## 📦 Features

- Text-based board rendering (3x5 grid)
- Turn-based input system
- Move validation logic
- Win condition detection
- Functional structure with recursion and immutability

---

## 🛠️ How to Run

1. Make sure [GHC / GHCi](https://www.haskell.org/ghc/) is installed.
2. Open terminal and navigate to the directory containing the file:
   ```bash
   cd path/to/project
   ```
3. Launch GHCi:
   ```bash
   ghci
   ```
4. Load the source file:
   ```haskell
   :load WarOfLetters.hs
   ```
5. Run the game:
   ```haskell
   main
   ```

---

## 👨‍🎓 Authors

- **Elman Kahkarmanov** 
- **Ahmet Salih Yaman** 
- **Esma Nur Gezi** 

---

## 📁 File Structure

- `WarOfLetters.hs` – Main source code (game logic)

---

## 📚 Educational Value

- Learn recursion and list processing
- Explore Haskell’s IO system
- Understand functional programming flow
- Practice modular and readable code structure

---

## 📸 Sample Output

```
Welcome!
X A - - X
B - - - Z
X C - - X
Enter the maximum number of total moves allowed:
Who starts first? Type 'firsts' or 'last':
...
```

---

## 📝 License

This project is for educational use only.
