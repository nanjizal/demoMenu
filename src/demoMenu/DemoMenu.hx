package demoMenu;
import folder.Folder;

typedef DemoStructure = {
  var options: Array<DemoOption>;
}

typedef DemoOption = {
  var menuName: String;
  var classPath: String;
}

// untested
class DemoMenu{
  
  public var demoJson: String = 'demoMenu.json';
  public var folderPath: String = '/';
  public var folder: Folder;
  public var instruction: String = "Please select a demo by index number: ";
  
  public static funtion main( args ){
     new DemoMenu( args );
  }
  
  public function new( args ){
    var menu: DemoStructure = setupFolder( args );
    var option: DemoOption = displayMenu( menu );
    runOption();
  }
  
  public function setupFolder( args ): DemoStructure {
    // could extract a folder name and json name but not bothering to process args, using hard coded.
    var folder = new Folder( folderPath );
    var data: DemoStructure = haxe.Json.parse( folder.loadText( demoJson ) );
    return data.options;
  }
  
  public function displayMenu( menu: Array<DemoOption> ): DemoOption {
    Sys.println( instruction );
    var demoOption: DemoOption;
    var str: String = '';
    for( i in 0...menu.length ){
      demoOption = menu[i];
      str = Std.string( i + 1 ) + '. ' + demoOption.menuName;
      Sys.println( str );
    }
    var optionNumber:String = Sys.stdin().readLine();
    var optionIndex = Std.parseInt( optionNumber );
    if( optionIndex.isNaN() {
       Sys.println('try again');
       Sys.println('');
       return displayMenu( menu );
    }
    optionIndex -= 1; // move to start 0.
    if( optionIndex > menu.length -1 || optionIndex < 0 ) {
       Sys.println('try again');
       Sys.println('');
       return displayMenu( menu );
    }
    return menu[ optionIndex ];
  }
  public function runOption( option: DemoOption ){
    Sys.println( 'running ' + option.menuName );
    var optionClass = option.classPath;
    folder.saveText('Main.hx',
'package;
function main(){
  new $optionClass();
}
';
     Sys.process( 'haxe compile.hxml', null, true );
     Sys.exit();
  }
}  
