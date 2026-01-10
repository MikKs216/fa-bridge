unit CxDBCheckBoxEx;

interface

uses
  SysUtils, Classes, Controls, cxControls, cxContainer, cxEdit, cxCheckBox,
  cxDBEdit, Graphics, Windows, Messages, faEdit, StdCtrls, cxLookAndFeels,
  dxGDIPlusClasses;

const
  cDefaultBorderColor = clHighlight;
  cDefaultSelectedColor = clWindow;
  
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
  cGlyphRadioBtn = //RadioButton - normal
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000ElKkF/WebF/sOGO/zXx1l/PX1Z/uA9J/+lKkFy0000'+
    '00000000000000000000000000000000000000ElKkF/WebF/sOGO/zXx1l/PX1Z/uA9J/+lKkF'+
    'y000000000000000000000000000000000000000000ElKkF/WebF/sOGO/zXx1l/PX1Z/uA9J/'+
    '+lKkFy00000000000000000000000000000003lxUl/ugfa/+2OFF/npwN/+/7b//xy+V/xyUN/'+
    'yS+b/+2OFF/YgcJ/x+th/m000000000000000000003lxUl/ugfa/+2OFF/npwN/+/7b//xy+V/'+
    'xyUN/yS+b/+2OFF/YgcJ/x+th/m000000000000000000003lxUl/ugfa/+2OFF/npwN/+/7b//'+
    'xy+V/xyUN/yS+b/+2OFF/YgcJ/x+th/m000000000000000000003YgsN/wB9k///+/l///////'+
    '//////////////////////+/l/eicx/ugjb/m000000000000000000003YgsN/wB9k///+/l//'+
    '///////////////////////////+/l/eicx/ugjb/m000000000000000000003YgsN/wB9k///'+
    '////////////////////////////////////eicx/ugjb/m000000000000000ElKkF/Wc3p///'+
    'xz/////////////////////////////////////////lt/u9Wy/+lKkFy0000000000ElKkF/Wc'+
    '3p///xz///////nqQZ/tOuf/zXx1V/TZYd/yT6e/////////lt/u9Wy/+lKkFy0000000000ElK'+
    'kF/Wc3p////////////IqjB/gAYe/vIKbF+egAZ/qjBI////////////u9Wy/+lKkFy00000000'+
    '00E2YK//npwN/////////////////////////////////////////////////yS+b/+2YK/y000'+
    '0000000E2YK//npwN///////BIgl/NU03/rtW0/zTu0F/NU03/rtW0//7HgF//////yS+b/+2YK'+
    '/y0000000000E2YK//npwN//////zBIql+0W83/W820/u20WF+0W83/W820/zBIql//////yS+b'+
    '/+2YK/y0000000000Dg35l/xy+Z////////////////////////////////////////////////'+
    '/+/7b/zc46Fy0000000000Dg35l/xy+Z//////zwFA//NU03/rtW0/zTu0F/NU03/rtW0/zwFA/'+
    '//////+/7b/zc46Fy0000000000Dg35l/xy+Z//////wYegF+0W83/W820/u20WF+0W83/W820/'+
    'wYegF//////+/7b/zc46Fy0000000000DTu0F//////////////////////////////////////'+
    '/////////////////lpv/zXx1ly0000000000DTu0F///////////zXx1l/NU03/rtW0/zTu0F/'+
    'NU03/rtW0/zXx1l///////lpv/zXx1ly0000000000DTu0F/+/Fd//////vIKbF+0W83/W820/u'+
    '20WF+0W83/W820/vIKbF///////lpv/zXx1ly0000000000Dg35l/xy+Z//////////////////'+
    '///////////////////////////////+/7b/zc46Fy0000000000Dg35l/xy+Z//////zwFA//N'+
    'U03/rtW0/zTu0F/NU03/rtW0/zwFA///////+/7b/zc46Fy0000000000Dg35l/xy+Z//////wY'+
    'egF+0W83/W820/u20WF+0W83/W820/wYegF//////+/7b/zc46Fy0000000000E2YLF/npwJ///'+
    '//////////////////////////////////////////////yS+a/+2YK/y0000000000E2YLF/np'+
    'wJ///////BJg//NU03/rtW0/zTu0F/NU03/rtW0//BHgV//////yS+a/+2YK/y0000000000E2Y'+
    'LF/npwJ//////zBIql+0W83/W820/u20WF+0W83/W820/zBIql//////yS+a/+2YK/y00000000'+
    '00EhKkF/Wbpl/////////////////////////////////////////////////u9Sx/+hKkFy000'+
    '0000000EhKkF/Wbpl////////////oqQd/teyh/zXx1l/UZol/yj6f////////////u9Sx/+hKk'+
    'Fy0000000000EhKkF/Wbpl////////////IqjB/gAYe/vIKbF+egAZ/qjBI////////////u9Sx'+
    '/+hKkFy0000000000000003Xfrx/wB9j///+/l/////////////////////////////+/l/eicx'+
    '/uQTU/m000000000000000000003Xfrx/wB9j///+/l/////////////////////////////+/l'+
    '/eicx/uQTU/m000000000000000000003Xfrx/wB9j/////////////////////////////////'+
    '//////eicx/uQTU/m000000000000000000003lxkp/ugfa/+2OFF/npwN/+/7a//xy+V/xyUJ/'+
    'yS+b/+2OFF/YgcJ/x+th/m000000000000000000003lxkp/ugfa/+2OFF/npwN/+/7a//xy+V/'+
    'xyUJ/yS+b/+2OFF/YgcJ/x+th/m000000000000000000003lxkp/ugfa/+2OFF/npwN/+/7a//'+
    'xy+V/xyUJ/yS+b/+2OFF/YgcJ/x+th/m0000000000000000000000000000000ElKkF/WebF/s'+
    'OGP/zXx1l/PX1d/uA9J/+lKkFy000000000000000000000000000000000000000000ElKkF/W'+
    'ebF/sOGP/zXx1l/PX1d/uA9J/+lKkFy000000000000000000000000000000000000000000El'+
    'KkF/WebF/sOGP/zXx1l/PX1d/uA9J/+lKkFy000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000';
  cGlyphRadioBtnB = //RadioButton - with border
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000000'+
    '0000000000000/FJh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/00000000000000'+
    '000000000000000000/FJh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/000000000'+
    '00000000000000000000000/FJh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/0000'+
    '00000000000000000000003qtBx/ug9L/+MiQV/WebF/uA9J/+2YK//WebF/uA9J/+MiQV/YebN'+
    '/zDo+/m000000000000000000003qtBx/ug9L/+MiQV/WebF/uA9J/+2YK//WebF/uA9J/+MiQV'+
    '/YebN/zDo+/m000000000000000000003qtBx/ug9L/+MiQV/WebF/uA9J/+2YK//WebF/uA9J/'+
    '+MiQV/YebN/zDo+/m000000000000000FJSll/UbJt/ugfa/+2OFF/npwN/+/7b//xy+V/xyUN/'+
    'yS+b/+2OFF/YgcJ/tfKz//JSlly0000000000FJSll/UbJt/ugfa/+2OFF/npwN/+/7b//xy+V/'+
    'xyUN/yS+b/+2OFF/YgcJ/tfKz//JSlly0000000000FJSll/UbJt/ugfa/+2OFF/npwN/+/7b//'+
    'xy+V/xyUN/yS+b/+2OFF/YgcJ/tfKz//JSlly00000/FJh/+AYLV/YgsN/wB9k/////////////'+
    '//////////////////////////eicx/ugjb/+AYLV/yzEl//FJh/+AYLV/YgsN/wB9k////////'+
    '///////////////////////////////eicx/ugjb/+AYLV/yzEl//FJh/+AYLV/YgsN/wB9k///'+
    '////////////////////////////////////eicx/ugjb/+AYLV/yzEl/xykV/+MiQV/Wc3p///'+
    '//////////////////////////////////////////////u9Wy/+MiQV/lov//xykV/+MiQV/Wc'+
    '3p////////////nqQZ/tOuf/zXx1V/TZYd/yT6e////////////u9Wy/+MiQV/lov//xykV/+Mi'+
    'QV/Wc3p////////////IqjB/gAYe/vIKbF+egAZ/qjBI////////////u9Wy/+MiQV/lov//uwT'+
    'U/+2YK//npwN/////////////////////////////////////////////////yS+b/+2YK//Zfr'+
    'x/uwTU/+2YK//npwN///////BIgl/NU03/rtW0/zTu0F/NU03/rtW0//7HgF//////yS+b/+2YK'+
    '//Zfrx/uwTU/+2YK//npwN//////zBIql+0W83/W820/u20WF+0W83/W820/zBIql//////yS+b'+
    '/+2YK//Zfrx/uA9J/+2YK//xy+Z////////////////////////////////////////////////'+
    '/+/7b/+2YK//WebF/uA9J/+2YK//xy+Z//////zwFA//NU03/rtW0/zTu0F/NU03/rtW0/zwFA/'+
    '//////+/7b/+2YK//WebF/uA9J/+2YK//xy+Z//////wYegF+0W83/W820/u20WF+0W83/W820/'+
    'wYegF//////+/7b/+2YK//WebF/uA9J/+2YK///////////////////////////////////////'+
    '/////////////////lpv/+2YK//WebF/uA9J/+2YK////////////zXx1l/NU03/rtW0/zTu0F/'+
    'NU03/rtW0/zXx1l///////lpv/+2YK//WebF/uA9J/+2YK////////////vIKbF+0W83/W820/u'+
    '20WF+0W83/W820/vIKbF///////lpv/+2YK//WebF/uA9J/+2YK//xy+Z//////////////////'+
    '///////////////////////////////+/7b/+2YK//WebF/uA9J/+2YK//xy+Z//////zwFA//N'+
    'U03/rtW0/zTu0F/NU03/rtW0/zwFA///////+/7b/+2YK//WebF/uA9J/+2YK//xy+Z//////wY'+
    'egF+0W83/W820/u20WF+0W83/W820/wYegF//////+/7b/+2YK//WebF/uwTU/+2YLF/npwJ///'+
    '//////////////////////////////////////////////yS+a/+2YK//Zfrx/uwTU/+2YLF/np'+
    'wJ///////BJg//NU03/rtW0/zTu0F/NU03/rtW0//BHgV//////yS+a/+2YK//Zfrx/uwTU/+2Y'+
    'LF/npwJ//////zBIql+0W83/W820/u20WF+0W83/W820/zBIql//////yS+a/+2YK//Zfrx/xyk'+
    'V/+MiQV/Wbpl/////////////////////////////////////////////////u9Sx/+MiQV/lov'+
    '//xykV/+MiQV/Wbpl////////////oqQd/teyh/zXx1l/UZol/yj6f////////////u9Sx/+MiQ'+
    'V/lov//xykV/+MiQV/Wbpl////////////IqjB/gAYe/vIKbF+egAZ/qjBI////////////u9Sx'+
    '/+MiQV/lov///FJh/+AYLV/Xfrx/wB9j///////////////////////////////////////eicx'+
    '/uQTU/+AYLV/yzEl//FJh/+AYLV/Xfrx/wB9j//////////////////////////////////////'+
    '/eicx/uQTU/+AYLV/yzEl//FJh/+AYLV/Xfrx/wB9j/////////////////////////////////'+
    '//////eicx/uQTU/+AYLV/yzEl/00000FJSll/UbJt/ugfa/+2OFF/npwN/+/7a//xy+V/xyUJ/'+
    'yS+b/+2OFF/YgcJ/tfKz//JSlly0000000000FJSll/UbJt/ugfa/+2OFF/npwN/+/7a//xy+V/'+
    'xyUJ/yS+b/+2OFF/YgcJ/tfKz//JSlly0000000000FJSll/UbJt/ugfa/+2OFF/npwN/+/7a//'+
    'xy+V/xyUJ/yS+b/+2OFF/YgcJ/tfKz//JSlly0000000000000003qtBx/ug9L/+MiQV/WebF/u'+
    'A9J/+2YK//WebF/uA9J/+MiQV/YebN/zDo+/m000000000000000000003qtBx/ug9L/+MiQV/W'+
    'ebF/uA9J/+2YK//WebF/uA9J/+MiQV/YebN/zDo+/m000000000000000000003qtBx/ug9L/+M'+
    'iQV/WebF/uA9J/+2YK//WebF/uA9J/+MiQV/YebN/zDo+/m00000000000000000000000000/F'+
    'Jh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/00000000000000000000000000000'+
    '000/FJh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/000000000000000000000000'+
    '00000000/FJh/+/Bd//Zfrx/uA9J/+2YK//WebF/uwTU/+/Bd//yzEl/0000000000000000';
  cGlyphRadioBtnD = //RadioButton - disabled (vsechny ikony jsou stejne, jako unchecked)
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000ENbvV/HqT7/nSN5/y71mV/5nSN/qT7H/+NbvVy0000'+
    '00000000000000000000000000000000000000ENbvV/HqT7/nSN5/y71mV/5nSN/qT7H/+NbvV'+
    'y000000000000000000000000000000000000000000ENbvV/HqT7/nSN5/y71mV/5nSN/qT7H/'+
    '+NbvVy00000000000000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//x+/l/v+Vd/'+
    'wUdf/y/Fp//KrDJ/x+/l/m000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//x+/l/'+
    'v+Vd/wUdf/y/Fp//KrDJ/x+/l/m000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//'+
    'x+/l/v+Vd/wUdf/y/Fp//KrDJ/x+/l/m000000000000000000003KrDJ/szlR/////////////'+
    '//////////////////////////Rszl/rDJK/m000000000000000000003KrDJ/szlR////////'+
    '///////////////////////////////Rszl/rDJK/m000000000000000000003KrDJ/szlR///'+
    '////////////////////////////////////Rszl/rDJK/m000000000000000ENbvV/Fpy////'+
    '//////////////////////////////////////////////py/F/+NbvVy0000000000ENbvV/Fp'+
    'y//////////////////////////////////////////////////py/F/+NbvVy0000000000ENb'+
    'vV/Fpy//////////////////////////////////////////////////py/F/+NbvVy00000000'+
    '00D7HqV/fwUd/////////////////////////////////////////////////wUdf/z7HqVy000'+
    '0000000D7HqV/fwUd/////////////////////////////////////////////////wUdf/z7Hq'+
    'Vy0000000000D7HqV/fwUd/////////////////////////////////////////////////wUdf'+
    '/z7HqVy0000000000CN5nV/v+Vd////////////////////////////////////////////////'+
    '/+Vdv/yN5nVy0000000000CN5nV/v+Vd///////////////////////////////////////////'+
    '//////+Vdv/yN5nVy0000000000CN5nV/v+Vd//////////////////////////////////////'+
    '///////////+Vdv/yN5nVy0000000000C30mF//////////////////////////////////////'+
    '/////////////////lx+/y71mVy0000000000C30mF/////////////////////////////////'+
    '//////////////////////lx+/y71mVy0000000000C30mF////////////////////////////'+
    '///////////////////////////lx+/y71mVy0000000000CN5nV/v+Vd//////////////////'+
    '///////////////////////////////+Vdv/yN5nVy0000000000CN5nV/v+Vd/////////////'+
    '////////////////////////////////////+Vdv/yN5nVy0000000000CN5nV/v+Vd////////'+
    '/////////////////////////////////////////+Vdv/yN5nVy0000000000D7HqV/fwUd///'+
    '//////////////////////////////////////////////wUdf/z7HqVy0000000000D7HqV/fw'+
    'Ud/////////////////////////////////////////////////wUdf/z7HqVy0000000000D7H'+
    'qV/fwUd/////////////////////////////////////////////////wUdf/z7HqVy00000000'+
    '00ENbvV/Fpy//////////////////////////////////////////////////py/F/+NbvVy000'+
    '0000000ENbvV/Fpy//////////////////////////////////////////////////py/F/+Nbv'+
    'Vy0000000000ENbvV/Fpy//////////////////////////////////////////////////py/F'+
    '/+NbvVy0000000000000003JqzF/szlR///////////////////////////////////////Rszl'+
    '/qzFJ/m000000000000000000003JqzF/szlR//////////////////////////////////////'+
    '/Rszl/qzFJ/m000000000000000000003JqzF/szlR/////////////////////////////////'+
    '//////Rszl/qzFJ/m000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//x+/l/v+Vd/'+
    'wUdf/y/Fp//KrDJ/x+/l/m000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//x+/l/'+
    'v+Vd/wUdf/y/Fp//KrDJ/x+/l/m000000000000000000003lx+//rDJK/y/Fp//fwUd/+Vdv//'+
    'x+/l/v+Vd/wUdf/y/Fp//KrDJ/x+/l/m0000000000000000000000000000000ENbvV/HqT7/n'+
    'SN5/y71mV/5nSN/qT7H/+NbvVy000000000000000000000000000000000000000000ENbvV/H'+
    'qT7/nSN5/y71mV/5nSN/qT7H/+NbvVy000000000000000000000000000000000000000000EN'+
    'bvV/HqT7/nSN5/y71mV/5nSN/qT7H/+NbvVy000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000';
  cGlyphCheckBox = //CheckBox - normal
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '00000000000000000F+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF'+
    '//vap//+PC/y0000000000F+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC/'+
    '//cJF//vap//+PC/y0000000000F+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap/'+
    '/+PC///cJF//vap//+PC/y0000000000F+PC///////////////////////////////////////'+
    '//////////////////////+PC/y0000000000F+PC//////////////////////////////////'+
    '///////////////////////////+PC/y0000000000F+PC/////////////////////////////'+
    '////////////////////////////////+PC/y0000000000F+PC////////////////////////'+
    '/////////////////////////////////////+PC/y0000000000F+PC//////////////////T'+
    'a3J/tvb6//////////////////////////////////+PC/y0000000000F+PC//////////////'+
    '///////////////////////////////////////////////+PC/y0000000000F+PC/////////'+
    '////////////////////////////////////////////////////+PC/y0000000000F+PC////'+
    '////////z+PHl/LU0d/rNW9/+cwWV////////////////////////////+PC/y0000000000F+P'+
    'C/////////////Zu+F+Oc9Z/rTNL//////////////////////////////////+PC/y00000000'+
    '00F+PC/////////////////////////////////////////////////////////////+PC/y000'+
    '0000000F+PC///////vQnd/zLu2V/bh6V/t8un/zLu2V/qtC3///////////////////////+PC'+
    '/y0000000000F+PC///////+FZu/vYOcFzlRs//Rszl/zNLrV//////////////////////////'+
    '//+PC/y0000000000F+PC//////////////////////////////////////////////////////'+
    '///////+PC/y0000000000F+PC//imex/rNW9/z+NGl///////////zT+5F/LUGh//Vdp//////'+
    '////////////+PC/y0000000000F+PC//u+FZ/c9YO/tz/V//gwkh/jBIq/szlR//LrTN//////'+
    '/////////////////+PC/y0000000000F+PC///////////////////////////////////////'+
    '//////////////////////+PC/y0000000000F+PC//LU0h/tP0q//////////////////tvy//'+
    'LUGh/rdmH//////////////////+PC/y0000000000F+PC/+ihAp/Vtz//+hgwl///////////x'+
    'IqjFzlRs//rTNL//////////////////+PC/y0000000000F+PC////////////////////////'+
    '/////////////////////////////////////+PC/y0000000000F+PC//qtC3/////////////'+
    '///////////////suih/rNW9/zkBA/////////////+PC/y0000000000F+PC//gwkh/wkhg///'+
    '///////////////////+qjBJ/Rszl/zNLrV////////////+PC/y0000000000F+PC/////////'+
    '////////////////////////////////////////////////////+PC/y0000000000F+PC////'+
    '///////////////////////////////////wxw8/zLu2V/afbt///////+PC/y0000000000F+P'+
    'C///////////////////////////////////////jBIq/szlR//LrTN///////+PC/y00000000'+
    '00F+PC/////////////////////////////////////////////////////////////+PC/y000'+
    '0000000F+PC////////////////////////////////////////////z+PHl/LU0d/xygV//+PC'+
    '/y0000000000F+PC////////////////////////////////////////////xIqjFzlRs//wkhg'+
    '//+PC/y0000000000F+PC//////////////////////////////////////////////////////'+
    '///////+PC/y0000000000F+PC/////////////////////////////////////////////////'+
    '/PX1x/rdmG//+PC/y0000000000F+PC////////////////////////////////////////////'+
    '//////LrTN///////+PC/y0000000000F+PC///////////////////////////////////////'+
    '//////////////////////+PC/y0000000000F+PC//////////////////////////////////'+
    '///////////////////////////+PC/y0000000000F+PC/////////////////////////////'+
    '////////////////////////////////+PC/y0000000000F+PC///cJF//vap//+PC///cJF//'+
    'vap//+PC///cJF//vap//+PC///cJF//vap//+PC/y0000000000F+PC///cJF//vap//+PC///'+
    'cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC/y0000000000F+PC///cJF//vap//+'+
    'PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC/y00000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000';
  cGlyphCheckBoxB = //CheckBox - with border
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000/va'+
    'p//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJ'+
    'F//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC'+
    '///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap'+
    '//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF'+
    '//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC/'+
    '//cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap/'+
    '/+PC///cJF//vap//+PC///cJF//vap//+PC///////////////////////////////////////'+
    '//////////////////////+PC///cJF//vap//+PC//////////////////////////////////'+
    '///////////////////////////+PC///cJF//vap//+PC/////////////////////////////'+
    '////////////////////////////////+PC///cJF//vap//+PC////////////////////////'+
    '/////////////////////////////////////+PC///cJF//vap//+PC//////////////////T'+
    'a3J/tvb6//////////////////////////////////+PC///cJF//vap//+PC//////////////'+
    '///////////////////////////////////////////////+PC///cJF//vap//+PC/////////'+
    '////////////////////////////////////////////////////+PC///cJF//vap//+PC////'+
    '////////z+PHl/LU0d/rNW9/+cwWV////////////////////////////+PC///cJF//vap//+P'+
    'C/////////////Zu+F+Oc9Z/rTNL//////////////////////////////////+PC///cJF//va'+
    'p//+PC/////////////////////////////////////////////////////////////+PC///cJ'+
    'F//vap//+PC///////vQnd/zLu2V/bh6V/t8un/zLu2V/qtC3///////////////////////+PC'+
    '///cJF//vap//+PC///////+FZu/vYOcFzlRs//Rszl/zNLrV//////////////////////////'+
    '//+PC///cJF//vap//+PC//////////////////////////////////////////////////////'+
    '///////+PC///cJF//vap//+PC//imex/rNW9/z+NGl///////////zT+5F/LUGh//Vdp//////'+
    '////////////+PC///cJF//vap//+PC//u+FZ/c9YO/tz/V//gwkh/jBIq/szlR//LrTN//////'+
    '/////////////////+PC///cJF//vap//+PC///////////////////////////////////////'+
    '//////////////////////+PC///cJF//vap//+PC//LU0h/tP0q//////////////////tvy//'+
    'LUGh/rdmH//////////////////+PC///cJF//vap//+PC/+ihAp/Vtz//+hgwl///////////x'+
    'IqjFzlRs//rTNL//////////////////+PC///cJF//vap//+PC////////////////////////'+
    '/////////////////////////////////////+PC///cJF//vap//+PC//qtC3/////////////'+
    '///////////////suih/rNW9/zkBA/////////////+PC///cJF//vap//+PC//gwkh/wkhg///'+
    '///////////////////+qjBJ/Rszl/zNLrV////////////+PC///cJF//vap//+PC/////////'+
    '////////////////////////////////////////////////////+PC///cJF//vap//+PC////'+
    '///////////////////////////////////wxw8/zLu2V/afbt///////+PC///cJF//vap//+P'+
    'C///////////////////////////////////////jBIq/szlR//LrTN///////+PC///cJF//va'+
    'p//+PC/////////////////////////////////////////////////////////////+PC///cJ'+
    'F//vap//+PC////////////////////////////////////////////z+PHl/LU0d/xygV//+PC'+
    '///cJF//vap//+PC////////////////////////////////////////////xIqjFzlRs//wkhg'+
    '//+PC///cJF//vap//+PC//////////////////////////////////////////////////////'+
    '///////+PC///cJF//vap//+PC/////////////////////////////////////////////////'+
    '/PX1x/rdmG//+PC///cJF//vap//+PC////////////////////////////////////////////'+
    '//////LrTN///////+PC///cJF//vap//+PC///////////////////////////////////////'+
    '//////////////////////+PC///cJF//vap//+PC//////////////////////////////////'+
    '///////////////////////////+PC///cJF//vap//+PC/////////////////////////////'+
    '////////////////////////////////+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//'+
    'vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///'+
    'cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+'+
    'PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//v'+
    'ap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///c'+
    'JF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+P'+
    'C///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF//vap//+PC///cJF/';
  cGlyphCheckBoxD = //CheckBox - disabled (vsechny ikony jsou stejne, jako unchecked)
    'Gat22W00000003O0000e0000BG0000y0000102000000000000343W00n0u0000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '00000000000000000FptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J'+
    '//FVq//ptzFy0000000000FptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF'+
    '/yz/J//FVq//ptzFy0000000000FptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq/'+
    '/ptzF/yz/J//FVq//ptzFy0000000000FptzF//////////////////////////////////////'+
    '//////////////////////ptzFy0000000000FptzF/////////////////////////////////'+
    '///////////////////////////ptzFy0000000000FptzF////////////////////////////'+
    '////////////////////////////////ptzFy0000000000FptzF///////////////////////'+
    '/////////////////////////////////////ptzFy0000000000FptzF//////////////////'+
    '//////////////////////////////////////////ptzFy0000000000FptzF/////////////'+
    '///////////////////////////////////////////////ptzFy0000000000FptzF////////'+
    '////////////////////////////////////////////////////ptzFy0000000000FptzF///'+
    '/////////////////////////////////////////////////////////ptzFy0000000000Fpt'+
    'zF////////////////////////////////////////////////////////////ptzFy00000000'+
    '00FptzF////////////////////////////////////////////////////////////ptzFy000'+
    '0000000FptzF////////////////////////////////////////////////////////////ptz'+
    'Fy0000000000FptzF//////////////////////////////////////////////////////////'+
    '//ptzFy0000000000FptzF/////////////////////////////////////////////////////'+
    '///////ptzFy0000000000FptzF////////////////////////////////////////////////'+
    '////////////ptzFy0000000000FptzF///////////////////////////////////////////'+
    '/////////////////ptzFy0000000000FptzF//////////////////////////////////////'+
    '//////////////////////ptzFy0000000000FptzF/////////////////////////////////'+
    '///////////////////////////ptzFy0000000000FptzF////////////////////////////'+
    '////////////////////////////////ptzFy0000000000FptzF///////////////////////'+
    '/////////////////////////////////////ptzFy0000000000FptzF//////////////////'+
    '//////////////////////////////////////////ptzFy0000000000FptzF/////////////'+
    '///////////////////////////////////////////////ptzFy0000000000FptzF////////'+
    '////////////////////////////////////////////////////ptzFy0000000000FptzF///'+
    '/////////////////////////////////////////////////////////ptzFy0000000000Fpt'+
    'zF////////////////////////////////////////////////////////////ptzFy00000000'+
    '00FptzF////////////////////////////////////////////////////////////ptzFy000'+
    '0000000FptzF////////////////////////////////////////////////////////////ptz'+
    'Fy0000000000FptzF//////////////////////////////////////////////////////////'+
    '//ptzFy0000000000FptzF/////////////////////////////////////////////////////'+
    '///////ptzFy0000000000FptzF////////////////////////////////////////////////'+
    '////////////ptzFy0000000000FptzF///////////////////////////////////////////'+
    '/////////////////ptzFy0000000000FptzF//////////////////////////////////////'+
    '//////////////////////ptzFy0000000000FptzF/////////////////////////////////'+
    '///////////////////////////ptzFy0000000000FptzF////////////////////////////'+
    '////////////////////////////////ptzFy0000000000FptzF/yz/J//FVq//ptzF/yz/J//'+
    'FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzFy0000000000FptzF/yz/J//FVq//ptzF/y'+
    'z/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzFy0000000000FptzF/yz/J//FVq//p'+
    'tzF/yz/J//FVq//ptzF/yz/J//FVq//ptzF/yz/J//FVq//ptzFy00000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000000'+
    '000000000000000000000000000000000000000000000000000000000000000000000000';

type
  TcxCheckBoxPropertiesEx = class (TcxCheckBoxProperties)
  private
    FReadOnly: boolean;
    procedure SetReadOnly(Value: boolean);
  public
    class function GetContainerClass: TcxContainerClass; override;
  published
    property OnChange;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
end;

type
  TcxDBCheckBoxEx = class(TcxDBCheckBox)
  private
    FSelectedColor: TColor;
    FBorderColor: TColor;
    FRepPage: integer;
    FRepPosX: integer;
    FRepPosY: integer;
    FRepFontSize: integer;
    FRepTrueText: string;
    FRepFalseText: string;
    FNextDirection: TNextDirection;
    FNextField,
    FNextFieldBack: string;
    FTransparent: boolean;
    FRepHide: boolean;
    FRadioButtonLook: boolean;
    FNewCheckLook: boolean;
    FFocused: boolean;
    procedure SetTransparent(Value: boolean);
    procedure SetRadioButtonLook(Value: boolean);
    procedure SetNewCheckLook(Value: boolean);
    procedure SetBorderColor(Value: TColor);
    function PrepareGlyphToLoad(AWithBorder: Boolean): string;
    procedure DoLoadGlyph(AWithBorder: Boolean = False);
    procedure LoadGlyph;

    function GetProperties: TcxCheckBoxPropertiesEx;
    procedure SetProperties(Value: TcxCheckBoxPropertiesEx);

  protected
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
    procedure Paint; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  published
    property SelectedColor: TColor read FSelectedColor write FSelectedColor
      default cDefaultSelectedColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor
      default cDefaultBorderColor;
    property RepPage: integer read FRepPage write FRepPage;
    property RepPosX: integer read FRepPosX write FRepPosX;
    property RepPosY: integer read FRepPosY write FRepPosY;
    property RepFontSize: integer read FRepFontSize write FRepFontSize;
    property RepTrueText: string read FRepTrueText write FRepTrueText;
    property RepFalseText: string read FRepFalseText write FRepFalseText;
    property NextDirection: TNextDirection read FNextDirection write FNextDirection;
    property NextField: string read FNextField write FNextField;
    property NextFieldBack: string read FNextFieldBack write FNextFieldBack;
    property Transparent: boolean read FTransparent write SetTransparent;
    property RepHide: boolean read FRepHide write FRepHide;
    property RadioButtonLook: boolean read FRadioButtonLook write SetRadioButtonLook;
    property NewCheckLook: boolean read FNewCheckLook write SetNewCheckLook;
    
    property Properties: TcxCheckBoxPropertiesEx read GetProperties write SetProperties;
  end;

procedure Register;

implementation

uses
  Forms;

{ TcxComboBoxPropertiesEx }


class function TcxCheckBoxPropertiesEx.GetContainerClass: TcxContainerClass;
begin
  Result := TcxDBCheckBoxEx;
end;

procedure TcxCheckBoxPropertiesEx.SetReadOnly(Value: boolean);
var
 ro: boolean;
begin
  ro := FReadOnly;
  FReadOnly := Value;
  if ro <> Value then
    TcxDBCheckBoxEx(Self.owner).LoadGlyph;
end;

{ TcxDBCheckBoxEx }

function TcxDBCheckBoxEx.GetProperties: TcxCheckBoxPropertiesEx;
begin
  Result := TcxCheckBoxPropertiesEx(FProperties);
end;

class function TcxDBCheckBoxEx.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCheckBoxPropertiesEx;
end;

procedure TcxDBCheckBoxEx.SetProperties(Value: TcxCheckBoxPropertiesEx);
begin
  FProperties.Assign(Value);
end;

constructor TcxDBCheckBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style.BorderStyle := ebsSingle;
  Style.BorderColor := cDefaultBorderColor;
  Style.HotTrack := FALSE;
  FSelectedColor := cDefaultSelectedColor;
  FBorderColor := cDefaultBorderColor;
  FFocused := False;
  ControlStyle := ControlStyle - [csSetCaption];
  AutoSize := FALSE;
  Height := 21;
end;

procedure TcxDBCheckBoxEx.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then begin
    FBorderColor := Value;
    Style.BorderColor := Value;
    Invalidate;
  end;
end;

procedure TcxDBCheckBoxEx.Paint;
var
  R: TRect;
begin
  inherited Paint;
  // Vykreslení vlastního borderu podle BorderColor (podobně jako faEdit)
  R := ClientRect;
  Canvas.Brush.Color := FBorderColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.FrameRect(R);
  // Pokud je fokus, vykreslíme silnější border
  if FFocused then begin
    InflateRect(R, -1, -1);
    Canvas.FrameRect(R);
  end;
end;

procedure TcxDBCheckBoxEx.SetRadioButtonLook(Value: boolean);
begin
  FRadioButtonLook := Value;
  if csDesigning in ComponentState then  // designtime
    LoadGlyph;
end;

procedure TcxDBCheckBoxEx.SetNewCheckLook(Value: boolean);
begin
  FNewCheckLook := Value;
  if csDesigning in ComponentState then  // designtime
    LoadGlyph;
end;

function TcxDBCheckBoxEx.PrepareGlyphToLoad(AWithBorder: Boolean): string;
begin
  Result := '';
  if FRadioButtonLook then begin
    if Properties.ReadOnly then
      Result := cGlyphRadioBtnD
    else if AWithBorder then
      Result := cGlyphRadioBtnB
    else
      Result := cGlyphRadioBtn;
  end
  else if FNewCheckLook then begin
    if Properties.ReadOnly then
      Result := cGlyphCheckBoxD
    else if AWithBorder then
      Result := cGlyphCheckBoxB
    else
      Result := cGlyphCheckBox;
  end;
end;

procedure TcxDBCheckBoxEx.DoLoadGlyph(AWithBorder: Boolean = False);
var
  gs: string;
  gi: TdxSmartImage;
  ms: TStream;
  glyphCount: Integer;

  function Decode64ToStream(AStr: string): TStream;
  var
    i: Integer;
    a: Integer;
    x: Integer;
    b: Integer;
    s: string;
  begin
    s := '';
    a := 0;
    b := 0;
    for i := 1 to Length(AStr) do begin
      x := Pos(AStr[i], codes64) - 1;
      if x >= 0 then begin
        b := b * 64 + x;
        a := a + 6;
        if a >= 8 then begin
          a := a - 8;
          x := b shr a;
          b := b mod (1 shl a);
          x := x mod 256;
          s := s + chr(x);
        end;
      end
      else
        Break;
    end;
    //
    Result := TStringStream.Create(s);
  end;

begin
  ms := TMemoryStream.Create;
  try
    gs := PrepareGlyphToLoad(AWithBorder);
    //
    ms := Decode64ToStream(gs);
    if ms.Size > 0 then begin
      gi := TdxSmartImage.Create; //gi := TdxSmartImage.CreateSize(26, 13);
      try
        ms.Seek(0, soFromBeginning);
        gi.LoadFromStream(ms);
        try
          if (gi.Width mod gi.Height) = 0 then
            glyphCount := (gi.Width div gi.Height)
          else
            glyphCount := 3;

          Properties.Glyph.Assign(gi);
          Properties.GlyphCount := glyphCount;
        except
        end;
      finally
        gi.Free;
      end;
    end;
  finally
    ms.Free;
  end;
end;

procedure TcxDBCheckBoxEx.LoadGlyph;
begin
  if FRadioButtonLook or FNewCheckLook then begin
    DoLoadGlyph;
  end
  else begin
    Properties.Glyph := nil;
    Properties.GlyphCount := 6;
  end;
end;

procedure TcxDBCheckBoxEx.Loaded;
begin
  inherited;
  ParentColor:=Transparent;
  Style.LookAndFeel.AssignedValues:=[lfvKind,lfvNativeStyle,lfvSkinName];
  Style.LookAndFeel.Kind:=lfOffice11;
  Style.LookAndFeel.NativeStyle:=FALSE;
  Style.LookAndFeel.SkinName:='';
  //
  LoadGlyph;
end; {Loaded}

procedure TcxDBCheckBoxEx.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  FFocused := True;
  if FRadioButtonLook or FNewCheckLook then
    DoLoadGlyph(True);
  Style.BorderStyle := ebsThick;
  Invalidate;
end;

procedure TcxDBCheckBoxEx.CMExit(var Message: TCMGotFocus);
begin
  inherited;
  FFocused := False;
  if FRadioButtonLook or FNewCheckLook then
    DoLoadGlyph;  
  Style.BorderStyle := ebsSingle;
  Invalidate;
end;

procedure TcxDBCheckBoxEx.SetTransparent(Value: boolean);
begin
  FTransparent := Value;
  ParentColor := FTransparent;
end;


procedure Register;
begin
  RegisterComponents('Edits', [TcxDBCheckBoxEx]);
end;

end.
