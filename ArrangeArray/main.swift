//
//  main.swift
//  ArrangeArray
//
//  Created by luqz on 2018/9/6.
//  Copyright © 2018年 jason. All rights reserved.
//

import Foundation

func arrangeArray(array: [Int]) -> [[Int]]{
    //元素个数为0时返回空数组
    if array.count == 0 {
        return [[Int]]()
    }
    
    //初始化
    var finalArray: [[Int]] = [[Int]]()
    var hasRepeatNumber = false                 //是否需要去重
    for i in 0 ..< array.count {
        for j in i+1 ..< array.count {
            if array[i] == array[j] {
                hasRepeatNumber = true
                break
            }
        }
        if hasRepeatNumber {
            break
        }
    }
    
//    var hashTable = [String : Set<String>]()    //利用字典和Set实现双散列查找
    var hashSet = Set<String>()                 //利用Set实现单散列查找

    
    //排列组合
    var tempArray = array
    let oneElement = tempArray.removeFirst()                //取出一个元素
    let returnedArray = arrangeArray(array: tempArray)     //剩余元素排列组合

    //将取出的元素插入到递归返回的数组中的每一个数组中的每一个位置，并添加到递归函数要返回的数组中
    if returnedArray.count == 0 {
        finalArray.append([oneElement])
    } else {
        for oneArray in returnedArray {
            for i in 0 ... oneArray.count {
                var newArray = oneArray
                newArray.insert(oneElement, at: i)

//                //双散列去重后添加到finalArray中
//                if hasRepeatNumber {
//                    addNewArrayFilterByDict(hashTable: &hashTable, newArray: &newArray, finalArray: &finalArray)
//                } else {
//                    finalArray.append(newArray)
//                }

                //单散列去重后添加到finalArray中
                if hasRepeatNumber {
                    addNewArrayFilterBySet(hashSet: &hashSet, newArray: &newArray, finalArray: &finalArray)
                } else {
                    finalArray.append(newArray)
                }

            }
        }
    }

    return finalArray
}

private func addNewArrayFilterByDict(hashTable: inout [String : Set<String>], newArray: inout [Int], finalArray: inout [[Int]] ) -> Void {
    var hashKey1 = String()
    var hashKey2 = String()
    for j in 0 ..< newArray.count {
        if j % 2 == 0 {
            if newArray[j] > 9 {                                //此判断对性能无明显影响
                hashKey1 += " " + String(newArray[j]) + " "     //两个相邻的非个位数相邻时多添加了一个空格，若增加一个末尾是否是空格的判断，在非个位数占比较少时明显增加运算时间
            } else {
                hashKey1 += String(newArray[j])
            }
        } else {
            if newArray[j] > 9 {
                hashKey2 += " " + String(newArray[j]) + " "
            } else {
                hashKey2 += String(newArray[j])
            }
        }
    }
    
    if let set = hashTable[hashKey1] {
        //已经有内部哈希表进行查找
        if set.contains(hashKey2) {
            //重复，丢弃
            
        } else {
            finalArray.append(newArray)
            hashTable[hashKey1]?.insert(hashKey2)
        }
    } else {
        //无内部哈希表时添加内部哈希表，注意字典为值类型
        finalArray.append(newArray)
        hashTable[hashKey1] = Set<String>()
        hashTable[hashKey1]?.insert(hashKey2)
    }

}

private func addNewArrayFilterBySet(hashSet: inout Set<String>, newArray: inout [Int], finalArray: inout [[Int]] ) -> Void {
    var hashKey = String()
    for element in newArray {
        if element > 9 {                                    //此判断对性能无明显影响
            hashKey += " " + String(element) + " "          //两个相邻的非个位数相邻时多添加了一个空格，若增加一个末尾是否是空格的判断，在非个位数占比较少时明显增加运算时间
        } else {
            hashKey += String(element)
        }
    }
    
    if hashSet.contains(hashKey) {
        //重复，丢弃
        
    } else {
        finalArray.append(newArray)
        hashSet.insert(hashKey)
    }
}


//测试
let array1 = [1, 2, 1, 2, 10, 2, 3, 2, 3, 10, 1, 1, 2, 1]       //双散列查找去重需68s，单散列查找去重需74s
let array2 = [1, 2, 1, 2, 1,  2, 3, 2, 3, 4,  1, 1, 2, 1]       //双散列查找去重需21s，单散列查找去重需27s

let array3 = [1, 2, 3, 4, 5, 6, 4, 2, 3, 1, 2]
let array4 = [1, 2, 1, 2]

print(Date())
let arrangedArray = arrangeArray(array: array2)
print(Date())

print(arrangedArray.count)


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

//let stringArray = ["没", "Bug", "没有", "Bug"]
//var indexArray = [Int]()
//for i in 0 ..< stringArray.count {
//    let string = stringArray[i]
//    let j = stringArray.index(of: string)!
//    indexArray.append(j)
//}
//
////print(indexArray)
//
//let arrangedIndex = arrangeArray(array: indexArray)
//
////print(arrangedIndex.count)
//
//for oneArray in arrangedIndex {
//    var string = ""
//    for i in 0 ..< oneArray.count {
//        if i == oneArray.count {
//            string += stringArray[oneArray[i]]
//        } else {
//            string += stringArray[oneArray[i]] + " "
//        }
//    }
//    print(string)
//}



/*   下面这一部分为前期测试部分，非最终代码，请忽略
 
 struct ArrangeArrayKit {
 //保存特定个数的数组的排列结果
 var dicForCount = [Int: [[Int]]]()
 
 //保存特定Array的排列结果
 var dicForLocations = [String:[[Int]]]()
 
 //计算递归次数
 var count = 0
 
 mutating func arrangeArray(array: [Any]) -> [[Any]] {
 var locationArray = [Int]()
 for i in 0 ..< array.count {
 locationArray.append(i)
 }
 
 print(Date())
 //        let arrangedLocations = arrangeLocation(locationArray: locationArray)
 //        let arrangedLocations = arrangeLocationByInsert(locationArray: locationArray)
 
 let arrangedLocations = arrangeLocationByStringCache(locationArray: locationArray)
 //        let arrangedLocations = arrangeLocationByCountCache(locationArray: locationArray.reversed()).reversed()
 print(Date())
 
 self.dicForLocations = [String:[[Int]]]()
 self.dicForCount = [Int: [[Int]]]()
 
 var returnedArray = [[Any]]()
 for locations in arrangedLocations {
 var oneArray = [Any]()
 //根据位置序列构造一个源数组的新排列
 for i in 0 ..< locations.count {
 oneArray.append(array[locations[i]])
 }
 //将该排列添加到待返回的结果中
 returnedArray.append(oneArray)
 }
 return returnedArray
 }
 
 //根据位置排列数组下标
 private mutating func arrangeLocation(locationArray: [Int]) -> [[Int]]{
 //元素个数为0时返回空数组
 if locationArray.count == 0 {
 return [[Int]]()
 }
 
 var finalArray: [[Int]] = []
 
 for i in 0 ..< locationArray.count {
 
 var tempArray = locationArray
 
 //取出一个元素
 let oneElement = tempArray.remove(at: i)
 
 //剩余元素排列组合
 let returnedArray = arrangeLocation(locationArray: tempArray)
 
 //将取出的元素和递归返回的数组中的每一个数组合并，并添加到递归函数要返回的数组中
 if returnedArray.count == 0{
 finalArray.append([oneElement])
 } else {
 for oneArray in returnedArray {
 finalArray.append([oneElement] + oneArray)
 }
 }
 }
 
 return finalArray
 }
 
 //根据位置排列数组下标
 private mutating func arrangeLocationByInsert(locationArray: [Int]) -> [[Int]]{
 //元素个数为0时返回空数组
 if locationArray.count == 0 {
 return [[Int]]()
 }
 
 var finalArray: [[Int]] = []
 
 var tempArray = locationArray
 
 //取出一个元素
 let oneElement = tempArray.removeFirst()
 
 //剩余元素排列组合
 let returnedArray = arrangeLocationByInsert(locationArray: tempArray)
 
 //将取出的元素插入到递归返回的数组中的每一个数组中，并添加到递归函数要返回的数组中
 if returnedArray.count == 0 {
 finalArray.append([oneElement])
 } else {
 for oneArray in returnedArray {
 for i in 0 ... oneArray.count {
 var newArray = oneArray
 newArray.insert(oneElement, at: i)
 finalArray.append(newArray)
 }
 }
 }
 
 return finalArray
 }
 
 //根据位置排列数组下标
 private mutating func arrangeLocationByCountCache(locationArray: [Int]) -> [[Int]]{
 //元素个数为0时返回空数组
 if locationArray.count == 0 {
 return [[Int]]()
 }
 
 //字典中不存在时开始排列
 var finalArray: [[Int]] = []
 
 for i in 0 ..< locationArray.count {
 var tempArray = locationArray
 
 //取出一个元素
 let oneElement = tempArray.remove(at: i)
 
 //剩余元素排列组合
 var returnedArray = [[Int]]()
 
 if let arrayForCount = dicForCount[tempArray.count] {
 //未计算过该序列但计算过改个数的数组按照字典排列
 for locations in arrayForCount {
 var oneArray = [Int]()
 for k in 0 ..< locations.count {
 oneArray.append((tempArray.reversed())[locations[k]])
 }
 returnedArray.append(oneArray)
 }
 
 } else {
 //没有计算过该个数的数组时递归排列
 returnedArray = arrangeLocationByCountCache(locationArray: tempArray)
 //添加字典
 if let _ = dicForCount[tempArray.count] {
 
 } else {
 dicForCount[tempArray.count] = returnedArray
 }
 }
 
 //将取出的元素和递归返回的数组中的每一个数组合并，并添加到递归函数要返回的数组中
 if returnedArray.count == 0{
 finalArray.append([oneElement])
 } else {
 for oneArray in returnedArray {
 finalArray.append([oneElement] + oneArray)
 }
 }
 }
 
 return finalArray
 }
 
 //根据位置排列数组下标
 private mutating func arrangeLocationByStringCache(locationArray: [Int]) -> [[Int]]{
 //元素个数为0时返回空数组
 if locationArray.count == 0 {
 return [[Int]]()
 }
 
 //根据array内容作为字典的key
 var string = ""
 for s in locationArray {
 string += String(s) + " "
 }
 
 if let arrangedArray = dicForLocations[string] {
 //已经计算过该数组顺序返回缓存序列
 return arrangedArray
 }
 
 //字典中不存在时开始排列
 var finalArray: [[Int]] = []
 
 for i in 0 ..< locationArray.count {
 var tempArray = locationArray
 
 //取出一个元素
 let oneElement = tempArray.remove(at: i)
 
 //剩余元素排列组合
 let returnedArray = arrangeLocationByStringCache(locationArray: tempArray)
 
 //将取出的元素和递归返回的数组中的每一个数组合并，并添加到递归函数要返回的数组中
 if returnedArray.count == 0{
 finalArray.append([oneElement])
 } else {
 for oneArray in returnedArray {
 finalArray.append([oneElement] + oneArray)
 }
 }
 }
 
 //添加字典
 dicForLocations[string] = finalArray
 
 return finalArray
 }
 
 }
 
 //例子
 //let array1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
 
 //let array1 = [1, 2, 3, 4]
 //let array1 = [1, 2]
 //
 //var arrangeArrayKit = ArrangeArrayKit()
 //let array2 : [[Int]] = arrangeArrayKit.arrangeArray(array: array1) as! [[Int]]
 //
 ////遍历数组并打印
 //for array in array2 {
 //    //合成新的字符串
 //    var string = ""
 //    for i in 0 ..< array.count {
 //        if i == array.count - 1 {
 //            string += String(array[i])
 //        } else {
 //            string += String(array[i]) + " "
 //        }
 //    }
 //    //打印字符串
 //    print(string)
 //}
 
 */
