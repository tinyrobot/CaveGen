package {	import flash.events.Event;		import flash.display.StageScaleMode;		import flash.utils.getTimer;		import flash.display.Sprite;	/**	 * @author tavisbooth	 * Generates a cave according to simple cellular automata rules.	 * Could also generate heighmaps for landscapes or textures for world tiles.	 * 	 * See http://pixelenvy.ca/wa/ca_cave.html	 */	 	public class CaveGen extends Sprite {		private var w : int = 32; //width in tiles/cells		private var h : int = 32; //height in tiles/cells		public static var tw : int = 10;  //visual width of a tile		public static var th : int = 10;  //visual height of a tile		public static var map : Array;   //map data structure				public function CaveGen() {			stage.scaleMode = StageScaleMode.NO_SCALE;						map = new Array();						//populate the map with random floors and walls			for(var i : int = 0; i < w; i++){				map.push(new Array(h));				for(var j : int = 0; j < map[0].length; j++){					if(i == 0 || i == w-1 || j == 0 || j == h - 1){ //border creation						map[i][j] = 1;					}else{						//percentage probability - less than 40% of tiles should end up as walls						map[i][j] = Math.random() < 0.4 ? 1 : 0;					}				}			}						//cellular automata rules to apply to the random noise			for(i = 0; i < w; i++){				for(j = 0; j < map[0].length; j++){					if(i>0 && j>0 && i<w-1 && j<h-1){												//get values (0 or 1) for each neighbor						var a : int = map[i-1][j-1];						var b : int = map[i-1][j];						var c : int = map[i-1][j+1];						var d : int = map[i][j-1];						var e : int = map[i][j+1];						var f : int = map[i+1][j-1];						var g : int = map[i+1][j];						var h : int = map[i+1][j+1];												//sum of neighbor values						var total : int = a+b+c+d+e+f+g+h;												//cell dies (becomes floor) if <=3 of its neighbors are walls						if(total <= 2){							map[i][j] = 0;						}else if(total >= 5){ //becomes wall if >=5 neighbors are walls							map[i][j] = 1;						}						//otherwise, leave it in its current state					}				}			}						//add fpscounter			addChild(new FPSCounter());						//add monster			addChild(new Monster(100,100));						//draw it			addEventListener(Event.ENTER_FRAME,draw);		}		//draws the map matrix		public function draw(e : Event)  : void{			graphics.clear();						//go through the map, draw red for floor and black for wall			for(var i : int = 0; i < map.length; i++){				for(var j : int = 0; j < map[0].length; j++){					//tileid: 1 = wall, 0 = floor					var tid : int = map[i][j];					switch(tid){						case 0:							graphics.beginFill(0xff0033);							graphics.drawRect(i*tw,j*th,tw,th);							graphics.endFill();							break;						case 1:							graphics.beginFill(0x000000);							graphics.drawRect(i*tw,j*th,tw,th);							graphics.endFill();							break;						default:							break;					}				}			}		}				public static function blocked(x : Number, y : Number) : Boolean{			return map[int(x/tw)][int(y/th)] == 0;		}	}}