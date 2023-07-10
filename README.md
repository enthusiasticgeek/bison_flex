# Bison and Flex examples

Bison (parser generator)[parser] and Flex (fast lexical analyzer generator)[scanner]  examples.

# Resources

https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html

https://aquamentus.com/flex_bison.html

https://www.cse.scu.edu/~m1wang/compiler/TutorialFlexBison.pdf

https://austinhenley.com/blog/teenytinycompiler1.html

# Build/Compile Code

All the examples have a simple Makefile present in the `src/<example>` folder. Simply run `make` command.

# Usage

All the examples have a Readme.md file present in the `src/<example>` folder describing the functionality of the code.

An example usage for `calculator3`:

`./calculator`
```
  (3*4.5)+5
  (4.5/5)-9
```

Another example usage for `calculator3`: 

`./calculator < input.txt`

In most cases, the examples follow the standard Bison and Flex binary usage. 

Readme.md file will be updated periodically to accurately reflect the usage.
