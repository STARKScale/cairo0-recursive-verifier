// %builtins output 
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word


struct InterValue{
    row: felt,
    value: felt,
}

func main()-> () {
    // alloc_locals;
    // local res: InterValue*;
    //need to replace this with built in
    let (vector: felt*) = alloc();
    assert vector[0]=1;
    assert vector[1]=2;
    assert vector[2]=3;
    let (matrix: felt**) = alloc();
    let (row1: felt*)= alloc();
    let (row2: felt*)= alloc();
    let (row3: felt*)= alloc();
    assert matrix[0]=row1;
    assert matrix[1]=row2;
    assert matrix[2]=row3;
    assert matrix[0][0]=1;
    assert matrix[0][1]=2;
    assert matrix[0][2]=3;
    assert matrix[1][0]=4;
    assert matrix[1][1]=5;
    assert matrix[1][2]=6;
    assert matrix[2][0]=7;
    assert matrix[2][1]=8;
    assert matrix[2][2]=9;
    let row_size=3;
    let col_size=3;
    // let (res: (row,value)*)= alloc();
  
    let (res: InterValue*)= alloc();
    let res_index=0;
    mat_vect(vector,matrix,0,0,res,row_size,col_size, res_index);
    // serialize_word(first);
    ret;
}

func mat_vect(vector:felt*, matrix: felt**, row: felt, col: felt, result: InterValue*, row_size: felt, col_size:felt, res_index:felt)-> InterValue*{
    if (row == row_size) {
        return result;
    }
    if (col!= col_size){
        let mat_val= matrix[row][col];
        let vec_val= vector[col];
        //result.append((row,mat_val*vec_val))
        let value= mat_val*vec_val;
        assert result[res_index]= InterValue(row,value);
        mat_vect(vector,matrix,row,col+1,result,row_size, col_size, res_index+1);
    } else{
        mat_vect(vector,matrix,row+1, 0,result,row_size, col_size, res_index);
    }
    return result;
}