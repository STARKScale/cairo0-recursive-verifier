from starkware.cairo.common.alloc import alloc

func main(){
    alloc_locals;
    let  jobid :felt =1;
    let ( inter: (felt,felt)*) = alloc();
    assert inter[0]=(0,1);
    assert inter[1]=(0,4);
    assert inter[2]=(0,9);
    assert inter[3]=(1,4);
    assert inter[4]=(1,10);
    assert inter[5]=(1,18);
    assert inter[6]=(2,7);
    assert inter[7]=(2,16);
    assert inter[8]=(2,27);
    
    
    const ROW_SIZE =3;
    const COL_SIZE =3;
    let start_index=jobid*COL_SIZE;
    let end_index= (jobid+1)*COL_SIZE;
    let res=0;
    reduce(inter,start_index,end_index,res);
    return();
}

func reduce(inter:(felt,felt)*, start_index:felt, end_index:felt, res:felt)-> (felt,felt){
    if (start_index==end_index){
        return (inter[start_index][0],res);
    } 
    let val =inter[start_index][1];
    // res= res + val;
    return reduce(inter=inter, start_index=start_index+1, end_index=end_index, res=res+val);

}