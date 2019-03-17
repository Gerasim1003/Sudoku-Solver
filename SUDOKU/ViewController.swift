//
//  ViewController.swift
//  SUDOKU
//
//  Created by Gerasim Israyelyan on 3/16/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var label: UILabel!
    
    var indexPath: IndexPath?
    
    //ui
    var clr: Set = [0,1,2,9,10,11,18,19,20,6,7,8,15,16,17,24,25,26,30,31,32,39,40,41,48,49,50,54,55,56,63,64,65,72,73,74,60,61,62,69,70,71,78,79,80]
    
    //grid
    var grid: [[Int]] = [[0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0],
                        
                         [0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0],
                        
                         [0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0],
                         [0,0,0, 0,0,0, 0,0,0]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    @IBAction func SolveButton(_ sender: Any) {
        
        let cells = self.collectionView.visibleCells as! [CollectionViewCell]
        
        for i in 0..<9 {
            for j in 0..<9 {
                grid[i][j] = Int(cells[i * 9 + j].field.text!)!
            }
        }

        
        if (SolveSudoku(&grid) == true) {
            //collectionView.reloadItems(at: [self.indexPath!])
            collectionView.reloadData()
            
            self.label.text = "Solved"
            
        } else {
            self.label.text = "No solution exists"
        }
        
        
        
    }
    
    func SolveSudoku(_ grid: inout [[Int]]) -> Bool {
        var row: Int = 0
        var col: Int = 0
        
        if (!findEmptyCells(grid, &row, &col)) {
            return true
        }
        for number in 1...9 {
            if (isSafe(grid, row, col, number))
            {
                grid[row][col] = number;
                if (SolveSudoku(&grid)) {
                    return true
                }
                grid[row][col] = 0;
            }
        }
        return false
    }
    
    func findEmptyCells(_ grid: [[Int]],_ row: inout Int,_ col: inout Int) -> Bool {
    
        for i in 0..<9 {
            for j in 0..<9 {
                row = i
                col = j
                if grid[i][j] == 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func usedInRow(_ grid: [[Int]],_  row: Int,_  number: Int) -> Bool {
        for j in 0..<9 {
            if grid[row][j] == number {
                return true
            }
        }
        return false
    }
    
    func usedInCol(_ grid: [[Int]],_  col: Int,_  number: Int) -> Bool {
        for i in 0..<9 {
            if grid[i][col] == number {
                return true
            }
        }
        return false
    }
    
    func usedInBlock(_ grid: [[Int]],_  blockRow: Int,_  blockCol: Int,_  number: Int) -> Bool {
        for i in 0..<3 {
            for j in 0..<3 {
                if (grid[i + blockRow][j + blockCol] == number) {
                    return true
                }
            }
        }
        return false
    }
    
    func isSafe(_ grid: [[Int]],_ row: Int,_ col: Int,_ number: Int) -> Bool {
        return !usedInRow(grid, row, number) && !usedInCol(grid, col, number) &&
            !usedInBlock(grid, row - row % 3 , col - col % 3, number);
    }
    

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if cell.field.text == "" {
            cell.field.text = String( grid[indexPath.row / 9][indexPath.row % 9] )
            self.indexPath = indexPath
        }
        cell.field.text = String( grid[indexPath.row / 9][indexPath.row % 9] )

        
        if self.clr.contains(indexPath.row) {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)
        }
        
        return cell
    }

    
}

