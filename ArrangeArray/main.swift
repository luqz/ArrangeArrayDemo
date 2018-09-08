//
//  main.swift
//  ArrangeArray
//
//  Created by luqz on 2018/9/6.
//  Copyright © 2018年 jason. All rights reserved.
//

import Foundation

func arrangeArray(array: [Int]) -> [[Int]]{
    var finalArray: [[Int]] = [[Int]]()
    
    //元素个数为0时返回空数组
    if array.count == 0 {
        return [[Int]]()
    }

    var hasRepeatNumber = false
    var maxNumber = 0

    for i in 0 ..< array.count {
        for j in i+1 ..< array.count {
            if array[i] == array[j] {
                hasRepeatNumber = true
                break
            } else if hasRepeatNumber{
                break
            }
        }
        if array[i] > maxNumber {
            maxNumber = array[i]
        }
    }

    //利用字典和Set实现双散列查找
//    var hashTable = [String : Set<String>]()

    //利用Set实现单散列查找
    var hashSet = Set<String>()

    var tempArray = array

    //取出一个元素
    let oneElement = tempArray.removeFirst()

    //剩余元素排列组合
    let returnedArray = arrangeArray(array: tempArray)

    //将取出的元素插入到递归返回的数组中的每一个数组中的每一个位置，并添加到递归函数要返回的数组中
    if returnedArray.count == 0 {
        finalArray.append([oneElement])
    } else {
        for oneArray in returnedArray {
            for i in 0 ... oneArray.count {
                var newArray = oneArray
                newArray.insert(oneElement, at: i)

//                //双散列去重
//                if hasRepeatNumber {
//                    var hashKey1 = String()
//                    var hashKey2 = String()
//                    for i in 0 ..< newArray.count {
//                        if i % 2 == 0 {
//                            if maxNumber > 9 {                              //此判断对性能无明显影响
//                                hashKey1 += String(newArray[i]) + " "       //多添加一倍的字符明显影响查找速度
//                            } else {
//                                hashKey1 += String(newArray[i])
//                            }
//                        } else {
//                            if maxNumber > 9 {
//                                hashKey2 += String(newArray[i]) + " "
//                            } else {
//                                hashKey2 += String(newArray[i])
//                            }
//                        }
//                    }
//
//                    if let set = hashTable[hashKey1] {
//                        //已经有内部哈希表进行查找
//                        if set.contains(hashKey2) {
//
//                        } else {
//                            finalArray.append(newArray)
//                            hashTable[hashKey1]?.insert(hashKey2)
//                        }
//
//                    } else {
//                        //无内部哈希表时添加内部哈希表，注意字典为值类型
//                        finalArray.append(newArray)
//                        hashTable[hashKey1] = Set<String>()
//                        hashTable[hashKey1]?.insert(hashKey2)
//                    }
//                } else {
//                    //不去重
//                    finalArray.append(newArray)
//                }

                //单散列去重
                if hasRepeatNumber {
                    var hashKey = String()
                    for i in newArray {
                        if maxNumber > 9 {              //此判断对性能无明显影响
                            hashKey += String(i) + " "  //多添加一倍的字符明显影响查找速度
                        } else {
                            hashKey += String(i)
                        }
                    }

                    if hashSet.contains(hashKey) {

                    } else {
                        finalArray.append(newArray)
                        hashSet.insert(hashKey)
                    }
                } else {
                    finalArray.append(newArray)
                }

            }
        }
    }

    return finalArray
}



let array1 = [1, 2, 1, 2, 1, 2, 3, 2, 3, 10, 1, 1, 2, 1]    //双散列查找去重需34s，单散列查找去重需39s
let array2 = [1, 2, 1, 2, 1, 2, 3, 2, 3, 4, 1, 1, 2, 1]     //双散列查找去重需21s，单散列查找去重需27s

let array3 = [1, 2, 3, 4, 5, 6, 4, 2, 3, 1, 2]
let array4 = [1, 2, 1, 2]

//print(Date())
let arrangedArray = arrangeArray(array: array4)
//print(Date())

//print(arrangedArray.count)


//遍历数组并打印
for i in 0 ..< arrangedArray.count {
    //合成新的字符串
    let array = arrangedArray[i]

    var string = ""
    for j in 0 ..< array.count {
        if j == array.count - 1 {
            string += String(array[j])
        } else {
            string += String(array[j]) + " "
        }
    }
    //打印字符串
    print(string)
}


//对于复杂类型数组可将元素的位置数组传入递归函数进行排列，然后再根据返回的位置索引进行打印

let stringArray = ["没", "Bug", "没有", "Bug"]
var indexArray = [Int]()
for i in 0 ..< stringArray.count {
    let string = stringArray[i]
    let j = stringArray.index(of: string)!
    indexArray.append(j)
}

//print(indexArray)

let arrangedIndex = arrangeArray(array: indexArray)

//print(arrangedIndex.count)

for oneArray in arrangedIndex {
    var string = ""
    for i in 0 ..< oneArray.count {
        if i == oneArray.count {
            string += stringArray[oneArray[i]]
        } else {
            string += stringArray[oneArray[i]] + " "
        }
    }
    print(string)
}

