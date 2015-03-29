//: Playground - noun: a place where people can play

import Foundation

// Haskell Int functions

func even<T:IntegerType>(i:T) -> Bool {
    return i % 2 == 0
}

func odd<T:IntegerType>(i:T) -> Bool {
    return i % 2 == 1
}

// OOP
extension Int {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return self % 2 == 1
    }
    
}

extension Int8 {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return self % 2 == 1
    }
    
}

extension Int32 {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return self % 2 == 1
    }
    
}

extension Int64 {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return self % 2 == 1
    }
    
}

even(0)
even(1)
even(2)
odd(0)
odd(1)
odd(2)
even(Int64(24))

1.isEven
1.isOdd
Int64(24).isEven


// -----------------------------------------------------------------------------

// secuencias de Collatz
// Tomamos un número natural.
// Si ese número es par lo dividimos por dos.
// Si es impar, lo multiplicamos por tres y le sumamos uno.
// Tomamos el número resultante y le aplicamos lo mismo, lo que produce un
// nuevo número y así sucesivamente.
// Resumiendo, obtenemos una secuencia de números.
// Se sabe que para todo número la secuencia termina con el uno.
// Así que empezamos con el número 13, obtenemos esta secuencia:
// 13, 40, 20, 10, 5, 16, 8, 4, 2, 1.
// 13 * 3 + 1 es igual a 40.
// 40 dividido por dos es 20, etc.
// Podemos ver que la secuencia tiene 10 términos.


// Ahora, lo que queremos saber es: para cada número entre el 1 y el 100
// ¿Cuántas secuencias tienen una longitud mayor que 15?

// Antes de nada creamos una función que produzca una secuencia

func collatzSequence<I: IntegerType>(int: I) -> [I] {
    if int == 1 { return [1] }
    if even(int) {
        return [int] + collatzSequence(int / 2)
    }
    else {
        return [int] + collatzSequence(int * 3 + 1)
    }
}

collatzSequence(1)
collatzSequence(2)
collatzSequence(3)
collatzSequence(33)

// la función que nos da la respuesta a nuestro problema:

func numLongChain() -> Int {
    return filter(map(Array(1..<100), collatzSequence), { $0.count > 15 }).count
}

let start = NSDate();
numLongChain()
NSDate().timeIntervalSinceDate(start)

// -----------------------------------------------------------------------------






























