<?php

if ( $_SERVER['argc'] < 2 ) {
    die("reference file must be specified\n");
}

$refFile = $_SERVER['argv'][1];

if ( !file_exists($refFile) ) {
    die("Reference file does not exist\n");
}

$refFileInfo = pathinfo($refFile);

if ( !is_numeric($refFileInfo['filename']) ) {
    die("Reference file name expected to be numeric\n");
}

$refFileDate = strtotime($refFileInfo['filename']);

$consecutiveMissedDays = 0;
$date = $refFileDate;
$files = array($refFile);
while ($consecutiveMissedDays < 5) {
    $result = getSimilar($refFileInfo['dirname'], date('Ymd', $date), array_slice($files, -3));
    if (!$result || 0 == count($result)) {
        $consecutiveMissedDays++;
    } else {
        $consecutiveMissedDays = 0;
        $file = $result[0];
        echo "$file\n";
        array_push($files, $file);
        
        $similarDir = $refFileInfo['dirname'].'/similar/'.$refFileInfo['filename'];
        if ( !file_exists($similarDir) ) {
            mkdir($similarDir, 0777, true);
        }
        
        $info = pathinfo($file);
        //echo $file.' --> '.$similarDir.'/'.$info['basename']."\n";
        copy($file, $similarDir.'/'.$info['basename']);
    }
    
    $date = mktime(0, 0, 0, date("m", $date) , date("d", $date)+1, date("Y", $date));
}



function getSimilar($path, $date, $refFiles) {
    $return = array();
    $bestResult = null;
    $bestFile = null;
    
    $dirHandle = @opendir($path) or die("Unable to open $path");
    while ($file = readdir($dirHandle)) {
        
        if ( '.' == $file || '..' == $file ) {
            continue;
        }
        
        $fileInfo = pathinfo($file);
        if ( !is_numeric($fileInfo['filename']) ) {
            continue;
        }
        
        //echo "$file ".substr($fileInfo['filename'], 0, strlen($date))."\n";
        if ( substr($fileInfo['filename'], 0, strlen($date)) != $date ) {
            continue;
        }
        
        $result = 0;
        
        foreach ($refFiles as $refFile) {
            $result += exec("compare -metric AE -fuzz 30% $refFile $path/$file output.jpg 2>&1");
        }
        //echo "$result\n";
        
        if ( null == $bestResult || $result < $bestResult ) {
            $bestResult = $result;
            $bestFile = "$path/$file";
        }
        
        //array_push($return, $file);
    }

    //closing the directory
    closedir($dir_handle);
    
    
    //$score = `compare -metric AE -fuzz 30% $path$datetime.jpg $path$prevFile output.jpg 2>&1`
    if (null == $bestFile) {
        return null;
    }
    return array($bestFile);
}

?>