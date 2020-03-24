pragma Singleton
import QtQuick 2.9

Object {

    FontLoader {
        id: regular
        source: "./fa-regular-400.ttf"
    }

    FontLoader {
        id: brands
        source: "./fa-brands-400.ttf"
    }

    FontLoader {
        id: solid
        source: "./fa-solid-900.ttf"
    }

    property string fontFamily: regular.name
    property string fontFamilyBrands: brands.name
    property string fontFamilySolid: solid.name

    // Icons 
    property string addressBook : "\uf2b9"
    property string addressBookO : "\uf2ba"
    property string addressCard : "\uf2bb"
    property string addressCardO : "\uf2bc"
    property string adjust : "\uf042"
    property string adn : "\uf170"
    property string alignCenter : "\uf037"
    property string alignJustify : "\uf039"
    property string alignLeft : "\uf036"
    property string alignRight : "\uf038"
    property string amazon : "\uf270"
    property string ambulance : "\uf0f9"
    property string americanSignLanguageInterpreting : "\uf2a3"
    property string anchor : "\uf13d"
    property string android : "\uf17b"
    property string angellist : "\uf209"
    property string angleDoubleDown : "\uf103"
    property string angleDoubleLeft : "\uf100"
    property string angleDoubleRight : "\uf101"
    property string angleDoubleUp : "\uf102"
    property string angleDown : "\uf107"
    property string angleLeft : "\uf104"
    property string angleRight : "\uf105"
    property string angleUp : "\uf106"
    property string apple : "\uf179"
    property string archive : "\uf187"
    property string areaChart : "\uf1fe"
    property string arrowCircleDown : "\uf0ab"
    property string arrowCircleLeft : "\uf0a8"
    property string arrowCircleODown : "\uf01a"
    property string arrowCircleOLeft : "\uf190"
    property string arrowCircleORight : "\uf18e"
    property string arrowCircleOUp : "\uf01b"
    property string arrowCircleRight : "\uf0a9"
    property string arrowCircleUp : "\uf0aa"
    property string arrowDown : "\uf063"
    property string arrowLeft : "\uf060"
    property string arrowRight : "\uf061"
    property string arrowUp : "\uf062"
    property string arrows : "\uf047"
    property string arrowsAlt : "\uf0b2"
    property string arrowsH : "\uf07e"
    property string arrowsV : "\uf07d"
    property string aslInterpreting : "\uf2a3"
    property string assistiveListeningSystems : "\uf2a2"
    property string asterisk : "\uf069"
    property string at : "\uf1fa"
    property string audioDescription : "\uf29e"
    property string automobile : "\uf1b9"
    property string backward : "\uf04a"
    property string balanceScale : "\uf24e"
    property string ban : "\uf05e"
    property string bandcamp : "\uf2d5"
    property string bank : "\uf19c"
    property string barChart : "\uf080"
    property string barChartO : "\uf080"
    property string barcode : "\uf02a"
    property string bars : "\uf0c9"
    property string bath : "\uf2cd"
    property string bathtub : "\uf2cd"
    property string battery : "\uf240"
    property string battery0 : "\uf244"
    property string battery1 : "\uf243"
    property string battery2 : "\uf242"
    property string battery3 : "\uf241"
    property string battery4 : "\uf240"
    property string batteryEmpty : "\uf244"
    property string batteryFull : "\uf240"
    property string batteryHalf : "\uf242"
    property string batteryQuarter : "\uf243"
    property string batteryThreeQuarters : "\uf241"
    property string bed : "\uf236"
    property string beer : "\uf0fc"
    property string behance : "\uf1b4"
    property string behanceSquare : "\uf1b5"
    property string bell : "\uf0f3"
    property string bellO : "\uf0a2"
    property string bellSlash : "\uf1f6"
    property string bellSlashO : "\uf1f7"
    property string bicycle : "\uf206"
    property string binoculars : "\uf1e5"
    property string birthdayCake : "\uf1fd"
    property string bitbucket : "\uf171"
    property string bitbucketSquare : "\uf172"
    property string bitcoin : "\uf15a"
    property string blackTie : "\uf27e"
    property string blind : "\uf29d"
    property string bluetooth : "\uf293"
    property string bluetoothB : "\uf294"
    property string bold : "\uf032"
    property string bolt : "\uf0e7"
    property string bomb : "\uf1e2"
    property string book : "\uf02d"
    property string bookmark : "\uf02e"
    property string bookmarkO : "\uf097"
    property string braille : "\uf2a1"
    property string briefcase : "\uf0b1"
    property string btc : "\uf15a"
    property string bug : "\uf188"
    property string building : "\uf1ad"
    property string buildingO : "\uf0f7"
    property string bullhorn : "\uf0a1"
    property string bullseye : "\uf140"
    property string bus : "\uf207"
    property string buysellads : "\uf20d"
    property string cab : "\uf1ba"
    property string calculator : "\uf1ec"
    property string calendar : "\uf073"
    property string calendarCheckO : "\uf274"
    property string calendarMinusO : "\uf272"
    property string calendarO : "\uf133"
    property string calendarPlusO : "\uf271"
    property string calendarTimesO : "\uf273"
    property string camera : "\uf030"
    property string cameraRetro : "\uf083"
    property string car : "\uf1b9"
    property string caretDown : "\uf0d7"
    property string caretLeft : "\uf0d9"
    property string caretRight : "\uf0da"
    property string caretSquareODown : "\uf150"
    property string caretSquareOLeft : "\uf191"
    property string caretSquareORight : "\uf152"
    property string caretSquareOUp : "\uf151"
    property string caretUp : "\uf0d8"
    property string cartArrowDown : "\uf218"
    property string cartPlus : "\uf217"
    property string cc : "\uf20a"
    property string ccAmex : "\uf1f3"
    property string ccDinersClub : "\uf24c"
    property string ccDiscover : "\uf1f2"
    property string ccJcb : "\uf24b"
    property string ccMastercard : "\uf1f1"
    property string ccPaypal : "\uf1f4"
    property string ccStripe : "\uf1f5"
    property string ccVisa : "\uf1f0"
    property string certificate : "\uf0a3"
    property string chain : "\uf0c1"
    property string chainBroken : "\uf127"
    property string check : "\uf00c"
    property string checkCircle : "\uf058"
    property string checkCircleO : "\uf05d"
    property string checkSquare : "\uf14a"
    property string checkSquareO : "\uf046"
    property string chevronCircleDown : "\uf13a"
    property string chevronCircleLeft : "\uf137"
    property string chevronCircleRight : "\uf138"
    property string chevronCircleUp : "\uf139"
    property string chevronDown : "\uf078"
    property string chevronLeft : "\uf053"
    property string chevronRight : "\uf054"
    property string chevronUp : "\uf077"
    property string child : "\uf1ae"
    property string chrome : "\uf268"
    property string circle : "\uf111"
    property string circleO : "\uf10c"
    property string circleONotch : "\uf1ce"
    property string circleThin : "\uf1db"
    property string clipboard : "\uf0ea"
    property string clockO : "\uf017"
    property string clone : "\uf24d"
    property string close : "\uf00d"
    property string cloud : "\uf0c2"
    property string cloudDownload : "\uf0ed"
    property string cloudUpload : "\uf0ee"
    property string cny : "\uf157"
    property string code : "\uf121"
    property string codeFork : "\uf126"
    property string codepen : "\uf1cb"
    property string codiepie : "\uf284"
    property string coffee : "\uf0f4"
    property string cog : "\uf013"
    property string cogs : "\uf085"
    property string columns : "\uf0db"
    property string comment : "\uf075"
    property string commentO : "\uf0e5"
    property string commenting : "\uf27a"
    property string commentingO : "\uf27b"
    property string comments : "\uf086"
    property string commentsO : "\uf0e6"
    property string compass : "\uf14e"
    property string compress : "\uf066"
    property string connectdevelop : "\uf20e"
    property string contao : "\uf26d"
    property string copy : "\uf0c5"
    property string copyright : "\uf1f9"
    property string creativeCommons : "\uf25e"
    property string creditCard : "\uf09d"
    property string creditCardAlt : "\uf283"
    property string crop : "\uf125"
    property string crosshairs : "\uf05b"
    property string css3 : "\uf13c"
    property string cube : "\uf1b2"
    property string cubes : "\uf1b3"
    property string cut : "\uf0c4"
    property string cutlery : "\uf0f5"
    property string dashboard : "\uf0e4"
    property string dashcube : "\uf210"
    property string database : "\uf1c0"
    property string deaf : "\uf2a4"
    property string deafness : "\uf2a4"
    property string dedent : "\uf03b"
    property string delicious : "\uf1a5"
    property string desktop : "\uf108"
    property string deviantart : "\uf1bd"
    property string diamond : "\uf219"
    property string digg : "\uf1a6"
    property string dollar : "\uf155"
    property string dotCircleO : "\uf192"
    property string download : "\uf019"
    property string dribbble : "\uf17d"
    property string driversLicense : "\uf2c2"
    property string driversLicenseO : "\uf2c3"
    property string dropbox : "\uf16b"
    property string drupal : "\uf1a9"
    property string edge : "\uf282"
    property string edit : "\uf044"
    property string eercast : "\uf2da"
    property string eject : "\uf052"
    property string ellipsisH : "\uf141"
    property string ellipsisV : "\uf142"
    property string empire : "\uf1d1"
    property string envelope : "\uf0e0"
    property string envelopeO : "\uf003"
    property string envelopeOpen : "\uf2b6"
    property string envelopeOpenO : "\uf2b7"
    property string envelopeSquare : "\uf199"
    property string envira : "\uf299"
    property string eraser : "\uf12d"
    property string etsy : "\uf2d7"
    property string eur : "\uf153"
    property string euro : "\uf153"
    property string exchange : "\uf0ec"
    property string exclamation : "\uf12a"
    property string exclamationCircle : "\uf06a"
    property string exclamationTriangle : "\uf071"
    property string expand : "\uf065"
    property string expeditedssl : "\uf23e"
    property string externalLink : "\uf08e"
    property string externalLinkSquare : "\uf14c"
    property string eye : "\uf06e"
    property string eyeSlash : "\uf070"
    property string eyedropper : "\uf1fb"
    property string fa : "\uf2b4"
    property string facebook : "\uf09a"
    property string facebookF : "\uf09a"
    property string facebookOfficial : "\uf230"
    property string facebookSquare : "\uf082"
    property string fastBackward : "\uf049"
    property string fastForward : "\uf050"
    property string fax : "\uf1ac"
    property string feed : "\uf09e"
    property string female : "\uf182"
    property string fighterJet : "\uf0fb"
    property string file : "\uf15b"
    property string fileArchiveO : "\uf1c6"
    property string fileAudioO : "\uf1c7"
    property string fileCodeO : "\uf1c9"
    property string fileExcelO : "\uf1c3"
    property string fileImageO : "\uf1c5"
    property string fileMovieO : "\uf1c8"
    property string fileO : "\uf016"
    property string filePdfO : "\uf1c1"
    property string filePhotoO : "\uf1c5"
    property string filePictureO : "\uf1c5"
    property string filePowerpointO : "\uf1c4"
    property string fileSoundO : "\uf1c7"
    property string fileText : "\uf15c"
    property string fileTextO : "\uf0f6"
    property string fileVideoO : "\uf1c8"
    property string fileWordO : "\uf1c2"
    property string fileZipO : "\uf1c6"
    property string filesO : "\uf0c5"
    property string film : "\uf008"
    property string filter : "\uf0b0"
    property string fire : "\uf06d"
    property string fireExtinguisher : "\uf134"
    property string firefox : "\uf269"
    property string firstOrder : "\uf2b0"
    property string flag : "\uf024"
    property string flagCheckered : "\uf11e"
    property string flagO : "\uf11d"
    property string flash : "\uf0e7"
    property string flask : "\uf0c3"
    property string flickr : "\uf16e"
    property string floppyO : "\uf0c7"
    property string folder : "\uf07b"
    property string folderO : "\uf114"
    property string folderOpen : "\uf07c"
    property string folderOpenO : "\uf115"
    property string font : "\uf031"
    property string fontAwesome : "\uf2b4"
    property string fonticons : "\uf280"
    property string fortAwesome : "\uf286"
    property string forumbee : "\uf211"
    property string forward : "\uf04e"
    property string foursquare : "\uf180"
    property string freeCodeCamp : "\uf2c5"
    property string frownO : "\uf119"
    property string futbolO : "\uf1e3"
    property string gamepad : "\uf11b"
    property string gavel : "\uf0e3"
    property string gbp : "\uf154"
    property string ge : "\uf1d1"
    property string gear : "\uf013"
    property string gears : "\uf085"
    property string genderless : "\uf22d"
    property string getPocket : "\uf265"
    property string gg : "\uf260"
    property string ggCircle : "\uf261"
    property string gift : "\uf06b"
    property string git : "\uf1d3"
    property string gitSquare : "\uf1d2"
    property string github : "\uf09b"
    property string githubAlt : "\uf113"
    property string githubSquare : "\uf092"
    property string gitlab : "\uf296"
    property string gittip : "\uf184"
    property string glass : "\uf000"
    property string glide : "\uf2a5"
    property string glideG : "\uf2a6"
    property string globe : "\uf0ac"
    property string google : "\uf1a0"
    property string googlePlus : "\uf0d5"
    property string googlePlusCircle : "\uf2b3"
    property string googlePlusOfficial : "\uf2b3"
    property string googlePlusSquare : "\uf0d4"
    property string googleWallet : "\uf1ee"
    property string graduationCap : "\uf19d"
    property string gratipay : "\uf184"
    property string grav : "\uf2d6"
    property string group : "\uf0c0"
    property string hSquare : "\uf0fd"
    property string hackerNews : "\uf1d4"
    property string handGrabO : "\uf255"
    property string handLizardO : "\uf258"
    property string handODown : "\uf0a7"
    property string handOLeft : "\uf0a5"
    property string handORight : "\uf0a4"
    property string handOUp : "\uf0a6"
    property string handPaperO : "\uf256"
    property string handPeaceO : "\uf25b"
    property string handPointerO : "\uf25a"
    property string handRockO : "\uf255"
    property string handScissorsO : "\uf257"
    property string handSpockO : "\uf259"
    property string handStopO : "\uf256"
    property string handshakeO : "\uf2b5"
    property string hardOfHearing : "\uf2a4"
    property string hashtag : "\uf292"
    property string hddO : "\uf0a0"
    property string header : "\uf1dc"
    property string headphones : "\uf025"
    property string heart : "\uf004"
    property string heartO : "\uf08a"
    property string heartbeat : "\uf21e"
    property string history : "\uf1da"
    property string home : "\uf015"
    property string hospitalO : "\uf0f8"
    property string hotel : "\uf236"
    property string hourglass : "\uf254"
    property string hourglass1 : "\uf251"
    property string hourglass2 : "\uf252"
    property string hourglass3 : "\uf253"
    property string hourglassEnd : "\uf253"
    property string hourglassHalf : "\uf252"
    property string hourglassO : "\uf250"
    property string hourglassStart : "\uf251"
    property string houzz : "\uf27c"
    property string html5 : "\uf13b"
    property string iCursor : "\uf246"
    property string idBadge : "\uf2c1"
    property string idCard : "\uf2c2"
    property string idCardO : "\uf2c3"
    property string ils : "\uf20b"
    property string image : "\uf03e"
    property string imdb : "\uf2d8"
    property string inbox : "\uf01c"
    property string indent : "\uf03c"
    property string industry : "\uf275"
    property string info : "\uf129"
    property string infoCircle : "\uf05a"
    property string inr : "\uf156"
    property string instagram : "\uf16d"
    property string institution : "\uf19c"
    property string internetExplorer : "\uf26b"
    property string intersex : "\uf224"
    property string ioxhost : "\uf208"
    property string italic : "\uf033"
    property string joomla : "\uf1aa"
    property string jpy : "\uf157"
    property string jsfiddle : "\uf1cc"
    property string key : "\uf084"
    property string keyboardO : "\uf11c"
    property string krw : "\uf159"
    property string language : "\uf1ab"
    property string laptop : "\uf109"
    property string lastfm : "\uf202"
    property string lastfmSquare : "\uf203"
    property string leaf : "\uf06c"
    property string leanpub : "\uf212"
    property string legal : "\uf0e3"
    property string lemonO : "\uf094"
    property string levelDown : "\uf149"
    property string levelUp : "\uf148"
    property string lifeBouy : "\uf1cd"
    property string lifeBuoy : "\uf1cd"
    property string lifeRing : "\uf1cd"
    property string lifeSaver : "\uf1cd"
    property string lightbulbO : "\uf0eb"
    property string lineChart : "\uf201"
    property string link : "\uf0c1"
    property string linkedin : "\uf0e1"
    property string linkedinSquare : "\uf08c"
    property string linode : "\uf2b8"
    property string linux : "\uf17c"
    property string list : "\uf03a"
    property string listAlt : "\uf022"
    property string listOl : "\uf0cb"
    property string listUl : "\uf0ca"
    property string locationArrow : "\uf124"
    property string lock : "\uf023"
    property string longArrowDown : "\uf175"
    property string longArrowLeft : "\uf177"
    property string longArrowRight : "\uf178"
    property string longArrowUp : "\uf176"
    property string lowVision : "\uf2a8"
    property string magic : "\uf0d0"
    property string magnet : "\uf076"
    property string mailForward : "\uf064"
    property string mailReply : "\uf112"
    property string mailReplyAll : "\uf122"
    property string male : "\uf183"
    property string map : "\uf279"
    property string mapMarker : "\uf041"
    property string mapO : "\uf278"
    property string mapPin : "\uf276"
    property string mapSigns : "\uf277"
    property string mars : "\uf222"
    property string marsDouble : "\uf227"
    property string marsStroke : "\uf229"
    property string marsStrokeH : "\uf22b"
    property string marsStrokeV : "\uf22a"
    property string maxcdn : "\uf136"
    property string meanpath : "\uf20c"
    property string medium : "\uf23a"
    property string medkit : "\uf0fa"
    property string meetup : "\uf2e0"
    property string mehO : "\uf11a"
    property string mercury : "\uf223"
    property string microchip : "\uf2db"
    property string microphone : "\uf130"
    property string microphoneSlash : "\uf131"
    property string minus : "\uf068"
    property string minusCircle : "\uf056"
    property string minusSquare : "\uf146"
    property string minusSquareO : "\uf147"
    property string mixcloud : "\uf289"
    property string mobile : "\uf10b"
    property string mobilePhone : "\uf10b"
    property string modx : "\uf285"
    property string money : "\uf0d6"
    property string moonO : "\uf186"
    property string mortarBoard : "\uf19d"
    property string motorcycle : "\uf21c"
    property string mousePointer : "\uf245"
    property string music : "\uf001"
    property string navicon : "\uf0c9"
    property string neuter : "\uf22c"
    property string newspaperO : "\uf1ea"
    property string objectGroup : "\uf247"
    property string objectUngroup : "\uf248"
    property string odnoklassniki : "\uf263"
    property string odnoklassnikiSquare : "\uf264"
    property string opencart : "\uf23d"
    property string openid : "\uf19b"
    property string opera : "\uf26a"
    property string optinMonster : "\uf23c"
    property string outdent : "\uf03b"
    property string pagelines : "\uf18c"
    property string paintBrush : "\uf1fc"
    property string paperPlane : "\uf1d8"
    property string paperPlaneO : "\uf1d9"
    property string paperclip : "\uf0c6"
    property string paragraph : "\uf1dd"
    property string paste : "\uf0ea"
    property string pause : "\uf04c"
    property string pauseCircle : "\uf28b"
    property string pauseCircleO : "\uf28c"
    property string paw : "\uf1b0"
    property string paypal : "\uf1ed"
    property string pencil : "\uf040"
    property string pencilSquare : "\uf14b"
    property string pencilSquareO : "\uf044"
    property string percent : "\uf295"
    property string phone : "\uf095"
    property string phoneSquare : "\uf098"
    property string photo : "\uf03e"
    property string pictureO : "\uf03e"
    property string pieChart : "\uf200"
    property string piedPiper : "\uf2ae"
    property string piedPiperAlt : "\uf1a8"
    property string piedPiperPp : "\uf1a7"
    property string pinterest : "\uf0d2"
    property string pinterestP : "\uf231"
    property string pinterestSquare : "\uf0d3"
    property string plane : "\uf072"
    property string play : "\uf04b"
    property string playCircle : "\uf144"
    property string playCircleO : "\uf01d"
    property string plug : "\uf1e6"
    property string plus : "\uf067"
    property string plusCircle : "\uf055"
    property string plusSquare : "\uf0fe"
    property string plusSquareO : "\uf196"
    property string podcast : "\uf2ce"
    property string powerOff : "\uf011"
    property string printIcon : "\uf02f"
    property string productHunt : "\uf288"
    property string puzzlePiece : "\uf12e"
    property string qq : "\uf1d6"
    property string qrcode : "\uf029"
    property string question : "\uf128"
    property string questionCircle : "\uf059"
    property string questionCircleO : "\uf29c"
    property string quora : "\uf2c4"
    property string quoteLeft : "\uf10d"
    property string quoteRight : "\uf10e"
    property string ra : "\uf1d0"
    property string random : "\uf074"
    property string ravelry : "\uf2d9"
    property string rebel : "\uf1d0"
    property string recycle : "\uf1b8"
    property string reddit : "\uf1a1"
    property string redditAlien : "\uf281"
    property string redditSquare : "\uf1a2"
    property string refresh : "\uf021"
    property string registered : "\uf25d"
    property string remove : "\uf00d"
    property string renren : "\uf18b"
    property string reorder : "\uf0c9"
    property string repeat : "\uf01e"
    property string reply : "\uf112"
    property string replyAll : "\uf122"
    property string resistance : "\uf1d0"
    property string retweet : "\uf079"
    property string rmb : "\uf157"
    property string road : "\uf018"
    property string rocket : "\uf135"
    property string rotateLeft : "\uf0e2"
    property string rotateRight : "\uf01e"
    property string rouble : "\uf158"
    property string rss : "\uf09e"
    property string rssSquare : "\uf143"
    property string rub : "\uf158"
    property string ruble : "\uf158"
    property string rupee : "\uf156"
    property string s15 : "\uf2cd"
    property string safari : "\uf267"
    property string save : "\uf0c7"
    property string scissors : "\uf0c4"
    property string scribd : "\uf28a"
    property string search : "\uf002"
    property string searchMinus : "\uf010"
    property string searchPlus : "\uf00e"
    property string sellsy : "\uf213"
    property string send : "\uf1d8"
    property string sendO : "\uf1d9"
    property string server : "\uf233"
    property string share : "\uf064"
    property string shareAlt : "\uf1e0"
    property string shareAltSquare : "\uf1e1"
    property string shareSquare : "\uf14d"
    property string shareSquareO : "\uf045"
    property string shekel : "\uf20b"
    property string sheqel : "\uf20b"
    property string shield : "\uf132"
    property string ship : "\uf21a"
    property string shirtsinbulk : "\uf214"
    property string shoppingBag : "\uf290"
    property string shoppingBasket : "\uf291"
    property string shoppingCart : "\uf07a"
    property string shower : "\uf2cc"
    property string signIn : "\uf090"
    property string signLanguage : "\uf2a7"
    property string signOutAlt : "\uf2f5"
    property string signOut : "\uf08b"
    property string signal : "\uf012"
    property string signing : "\uf2a7"
    property string simplybuilt : "\uf215"
    property string sitemap : "\uf0e8"
    property string skyatlas : "\uf216"
    property string skype : "\uf17e"
    property string slack : "\uf198"
    property string sliders : "\uf1de"
    property string slideshare : "\uf1e7"
    property string smileO : "\uf118"
    property string snapchat : "\uf2ab"
    property string snapchatGhost : "\uf2ac"
    property string snapchatSquare : "\uf2ad"
    property string snowflakeO : "\uf2dc"
    property string soccerBallO : "\uf1e3"
    property string sort : "\uf0dc"
    property string sortAlphaAsc : "\uf15d"
    property string sortAlphaDesc : "\uf15e"
    property string sortAmountAsc : "\uf160"
    property string sortAmountDesc : "\uf161"
    property string sortAsc : "\uf0de"
    property string sortDesc : "\uf0dd"
    property string sortDown : "\uf0dd"
    property string sortNumericAsc : "\uf162"
    property string sortNumericDesc : "\uf163"
    property string sortUp : "\uf0de"
    property string soundcloud : "\uf1be"
    property string spaceShuttle : "\uf197"
    property string spinner : "\uf110"
    property string spoon : "\uf1b1"
    property string spotify : "\uf1bc"
    property string square : "\uf0c8"
    property string squareO : "\uf096"
    property string stackExchange : "\uf18d"
    property string stackOverflow : "\uf16c"
    property string star : "\uf005"
    property string starHalf : "\uf089"
    property string starHalfEmpty : "\uf123"
    property string starHalfFull : "\uf123"
    property string starHalfO : "\uf123"
    property string starO : "\uf006"
    property string steam : "\uf1b6"
    property string steamSquare : "\uf1b7"
    property string stepBackward : "\uf048"
    property string stepForward : "\uf051"
    property string stethoscope : "\uf0f1"
    property string stickyNote : "\uf249"
    property string stickyNoteO : "\uf24a"
    property string stop : "\uf04d"
    property string stopCircle : "\uf28d"
    property string stopCircleO : "\uf28e"
    property string streetView : "\uf21d"
    property string strikethrough : "\uf0cc"
    property string stumbleupon : "\uf1a4"
    property string stumbleuponCircle : "\uf1a3"
    property string subscript : "\uf12c"
    property string subway : "\uf239"
    property string suitcase : "\uf0f2"
    property string sunO : "\uf185"
    property string superpowers : "\uf2dd"
    property string superscript : "\uf12b"
    property string support : "\uf1cd"
    property string table : "\uf0ce"
    property string tablet : "\uf10a"
    property string tachometer : "\uf0e4"
    property string tag : "\uf02b"
    property string tags : "\uf02c"
    property string tasks : "\uf0ae"
    property string taxi : "\uf1ba"
    property string telegram : "\uf2c6"
    property string television : "\uf26c"
    property string tencentWeibo : "\uf1d5"
    property string terminal : "\uf120"
    property string textHeight : "\uf034"
    property string textWidth : "\uf035"
    property string th : "\uf00a"
    property string thLarge : "\uf009"
    property string thList : "\uf00b"
    property string themeisle : "\uf2b2"
    property string thermometer : "\uf2c7"
    property string thermometer0 : "\uf2cb"
    property string thermometer1 : "\uf2ca"
    property string thermometer2 : "\uf2c9"
    property string thermometer3 : "\uf2c8"
    property string thermometer4 : "\uf2c7"
    property string thermometerEmpty : "\uf2cb"
    property string thermometerFull : "\uf2c7"
    property string thermometerHalf : "\uf2c9"
    property string thermometerQuarter : "\uf2ca"
    property string thermometerThreeQuarters : "\uf2c8"
    property string thumbTack : "\uf08d"
    property string thumbsDown : "\uf165"
    property string thumbsODown : "\uf088"
    property string thumbsOUp : "\uf087"
    property string thumbsUp : "\uf164"
    property string ticket : "\uf145"
    property string times : "\uf00d"
    property string timesCircle : "\uf057"
    property string timesCircleO : "\uf05c"
    property string timesRectangle : "\uf2d3"
    property string timesRectangleO : "\uf2d4"
    property string tint : "\uf043"
    property string toggleDown : "\uf150"
    property string toggleLeft : "\uf191"
    property string toggleOff : "\uf204"
    property string toggleOn : "\uf205"
    property string toggleRight : "\uf152"
    property string toggleUp : "\uf151"
    property string trademark : "\uf25c"
    property string train : "\uf238"
    property string transgender : "\uf224"
    property string transgenderAlt : "\uf225"
    property string trash : "\uf1f8"
    property string trashO : "\uf014"
    property string tree : "\uf1bb"
    property string trello : "\uf181"
    property string tripadvisor : "\uf262"
    property string trophy : "\uf091"
    property string truck : "\uf0d1"
    property string tryIcon : "\uf195"
    property string tty : "\uf1e4"
    property string tumblr : "\uf173"
    property string tumblrSquare : "\uf174"
    property string turkishLira : "\uf195"
    property string tv : "\uf26c"
    property string twitch : "\uf1e8"
    property string twitter : "\uf099"
    property string twitterSquare : "\uf081"
    property string umbrella : "\uf0e9"
    property string underline : "\uf0cd"
    property string undo : "\uf0e2"
    property string universalAccess : "\uf29a"
    property string university : "\uf19c"
    property string unlink : "\uf127"
    property string unlock : "\uf09c"
    property string unlockAlt : "\uf13e"
    property string unsorted : "\uf0dc"
    property string upload : "\uf093"
    property string usb : "\uf287"
    property string usd : "\uf155"
    property string user : "\uf007"
    property string userCircle : "\uf2bd"
    property string userCircleO : "\uf2be"
    property string userMd : "\uf0f0"
    property string userO : "\uf2c0"
    property string userPlus : "\uf234"
    property string userSecret : "\uf21b"
    property string userTimes : "\uf235"
    property string users : "\uf0c0"
    property string vcard : "\uf2bb"
    property string vcardO : "\uf2bc"
    property string venus : "\uf221"
    property string venusDouble : "\uf226"
    property string venusMars : "\uf228"
    property string viacoin : "\uf237"
    property string viadeo : "\uf2a9"
    property string viadeoSquare : "\uf2aa"
    property string videoCamera : "\uf03d"
    property string vimeo : "\uf27d"
    property string vimeoSquare : "\uf194"
    property string vine : "\uf1ca"
    property string vk : "\uf189"
    property string volumeControlPhone : "\uf2a0"
    property string volumeDown : "\uf027"
    property string volumeOff : "\uf026"
    property string volumeUp : "\uf028"
    property string warning : "\uf071"
    property string wechat : "\uf1d7"
    property string weibo : "\uf18a"
    property string weixin : "\uf1d7"
    property string whatsapp : "\uf232"
    property string wheelchair : "\uf193"
    property string wheelchairAlt : "\uf29b"
    property string wifi : "\uf1eb"
    property string wikipediaW : "\uf266"
    property string windowClose : "\uf2d3"
    property string windowCloseO : "\uf2d4"
    property string windowMaximize : "\uf2d0"
    property string windowMinimize : "\uf2d1"
    property string windowRestore : "\uf2d2"
    property string windows : "\uf17a"
    property string won : "\uf159"
    property string wordpress : "\uf19a"
    property string wpbeginner : "\uf297"
    property string wpexplorer : "\uf2de"
    property string wpforms : "\uf298"
    property string wrench : "\uf0ad"
    property string xing : "\uf168"
    property string xingSquare : "\uf169"
    property string yCombinator : "\uf23b"
    property string yCombinatorSquare : "\uf1d4"
    property string yahoo : "\uf19e"
    property string yc : "\uf23b"
    property string ycSquare : "\uf1d4"
    property string yelp : "\uf1e9"
    property string yen : "\uf157"
    property string yoast : "\uf2b1"
    property string youtube : "\uf167"
    property string youtubePlay : "\uf16a"
    property string youtubeSquare : "\uf166"
}
