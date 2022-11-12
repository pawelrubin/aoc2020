open System.IO

let path = "./input.txt"
let lines  = File.ReadLines(path)                 

// TODO: rewrite to lazy sequence
let splitBy sequence sep = 
    let rec splitter  = fun groups group sequence' ->
        match sequence' with
        | [] -> groups
        | [head] -> groups @ [group @ [head]]
        | head :: tail when head.Equals(sep)-> splitter (groups @ [group]) [] tail
        | head :: tail -> splitter groups (group @ [head]) tail

    splitter [] [] sequence

let splitByEmptyLine lines = splitBy lines "" 

let groups = 
    lines 
    |> Seq.toList 
    |> splitByEmptyLine 

// Task 1
let anyone =
    String.concat ""
    >> Seq.distinct
    >> Seq.length

// Task 2
let everyone: list<string> -> int = 
    List.map((fun c -> c.ToCharArray()) >> Set.ofArray)
    >> (List.reduce Set.intersect) 
    >> Set.count

let task f = 
    groups
    |> List.map f 
    |> List.sum 
    |> printfn "%d"

task anyone  // task1
task everyone  // task2
