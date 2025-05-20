$.ajax({
    url:"dowload.php",
    type:"post",
    dataType:"json",
    data: {filename: CyrptoJS.MD5('file_1.pdf').toString()},
    success.funtion(result){
        //
    }
});
