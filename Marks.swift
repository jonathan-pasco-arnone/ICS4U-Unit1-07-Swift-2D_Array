/*
* This program generates marks
* after reading in 2 text files.
*
* @author  Jonathan Pasco-Arnone
* @version 1.0
* @since   2021-12-05
*/

import Foundation

func generateGaussin() -> String {
    let randomNumber = Int.random(in: 50..<100)
    return String(randomNumber)
}

func mergeArrays(arrayOfStudents: [String], arrayOfAssignments: [String]) -> [[String]] {

    var combinedArray: [[String]] = []
    let quantityAssignments: Int = arrayOfAssignments.count
    let quantityStudents: Int = arrayOfStudents.count

    for counter in 0..<quantityStudents {

        combinedArray.append([String]())
        combinedArray[counter].append(arrayOfStudents[counter])

        for _ in 0..<quantityAssignments {
            combinedArray[counter].append(generateGaussin())
        }
    }

    return combinedArray
}

func fileToArray(file: String) throws -> [String] {
    var returnValue = [String]()
    do {
        // Read file.
        let text = try String(contentsOfFile: file)
        let rows = text.split(separator: "\r\n")
        var array = [String]()

        // Make required amount of rows.
        array.reserveCapacity(rows.count)

        for singleRow in rows where !rows.isEmpty {
            array.append(String(singleRow))
        }

        returnValue = array
    // If the file cannot be read then it will print this error.
    } catch {
        print("File cannot be read properly.")
        returnValue = ["fail"]
    }
    return returnValue
}

let listOfStudents = try fileToArray(file: CommandLine.arguments[1])
let listOfAssignments = try fileToArray(file: CommandLine.arguments[2])
if listOfStudents[0] == "fail" || listOfAssignments[0] == "fail" {
    print("One of the inputed arrays failed to read")
} else {
    let combinedArray = mergeArrays(arrayOfStudents: listOfStudents, arrayOfAssignments: listOfAssignments)

    print(listOfAssignments.joined(separator: ", "))
    for row in combinedArray {
        print(row.joined(separator: " "))
    }

    // Create file or replace contents of existing file
    let text = ""
    do {
        try text.write(to: URL(fileURLWithPath: "./marks.csv"), atomically: false, encoding: .utf8)
    } catch {
        print("could not creat or find file")
    }

    if let makeFile = try? FileHandle(forUpdating:
        URL(fileURLWithPath: "./marks.csv")) {

        // Go to the end of the file
        makeFile.seekToEndOfFile()
        let organizedAssignments = ", " + listOfAssignments.joined(separator: ", ") + "\n"

        makeFile.write(organizedAssignments.data(using: .utf8)!)

        for singleArray in combinedArray {
            let arrayToString = singleArray.joined(separator: ", ") + "\n"
            makeFile.seekToEndOfFile()
            makeFile.write(arrayToString.data(using: .utf8)!)
        }

        makeFile.closeFile()
    }
}
