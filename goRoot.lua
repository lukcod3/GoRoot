
platform.apilevel = '2.0'     

--------------------------
---- FormulaPro 1.42b ----
----  (Nov 11, 2015)  ----
----  LGLP 3 License  ----
--------------------------
----   Jim Bauwens    ----
---- Adrien Bertrand  ----
--------------------------
----  TI-Planet.org   ----
---- Inspired-Lua.org ----
--------------------------

local utf8 = string.uchar

SubNumbers = {185, 178, 179, 8308, 8309, 8310, 8311, 8312, 8313}
function numberToSub(w, n)
	return w .. utf8(SubNumbers[tonumber(n)])
end

Constants = {}
Constants["g"      ]	= {info="Acceleration due to gravity"        , value="9.81"                  , unit="m*s^-2"             }
Constants["mu"     ]	= {info="Atomic mass unit"                   , value="1.66 * 10^-27"         , unit="kg"                 }
Constants["u"      ]	= Constants["mu"]
Constants["N"      ]	= {info="Avogadro's Number"                  , value="6.022 * 10^23"         , unit="mol^-1"             }
Constants["a0"     ]	= {info="Bohr radius"                        , value="0.529 * 10^-10"        , unit="m"                  }
Constants["k"      ]	= {info="Boltzmann constant"                 , value="1.38 * 10^-23"         , unit="J/K^-1"             }
Constants["em"     ]	= {info="Electron charge to mass ratio"      , value="-1.7588 * 10^11"       , unit="C/kg^-1"            }
Constants["re"     ]	= {info="Electron classical radius"          , value="2.818 * 10^-15"        , unit="m"                  }
Constants["mec2"   ]	= {info="Electron mass energy (J)"           , value="8.187 * 10^-14"        , unit="J"                  }
Constants["mec2DUP"]	= {info="Electron mass energy (MeV)"         , value="0.511"                 , unit="MeV"                }
Constants["me"     ]	= {info="Electron rest mass"                 , value="9.109 * 10^-31"        , unit="kg"                 }
Constants["F"      ]	= {info="Faraday constant"                   , value="9.649 * 10^4"          , unit="C/mol^-1"           }
Constants[utf8(945)]	= {info="Fine-structure constant"            , value="7.297 * 10^-3"         , unit=nil                  }
Constants["R"      ]	= {info="Gas constant"                       , value="8.314"                 , unit="J/((mol^-1)*(K^-1))"}
Constants["G"      ]	= {info="Gravitational constant"             , value="6.67 * 10^-11"         , unit="Nm^2/kg^-2"         }
Constants["mnc2"   ]	= {info="Neutron mass energy (J)"            , value="1.505 * 10^-10"        , unit="J"                  }
Constants["mnc2DUP"]	= {info="Neutron mass energy (MeV)"          , value="939.565"               , unit="MeV"                }
Constants["mn"     ]	= {info="Neutron rest mass"                  , value="1.675 * 10^-27"        , unit="kg"                 }
--Constants["mn/me"]	= {info="Neutron-electron mass ratio"        , value="1838.68"               , unit=nil                  }
--Constants["mn/mp"]	= {info="Neutron-proton mass ratio"          , value="1.0014"                , unit=nil                  }
Constants[utf8(956).."0"]	= {info="Permeability of a vacuum"       , value="4*pi * 10^-7"          , unit="N/A^-2"             }
Constants[utf8(949).."0"]	= {info="Permittivity of a vacuum"       , value="8.854 * 10^-12"        , unit="F/m^-1"             }
Constants["h"      ]	= {info="Planck constant"                    , value="6.626 * 10^-34"        , unit="J/s"                }
Constants["mpc2"   ]	= {info="Proton mass energy (J)"             , value="1.503 * 10^-10"        , unit="J"                  }
Constants["mpc2DUP"]	= {info="Proton mass energy (MeV)"           , value="938.272"               , unit="MeV"                }
Constants["mp"     ]	= {info="Proton rest mass"                   , value="1.6726 * 10^-27"       , unit="kg"                 }
Constants["pe"     ]	= {info="Proton-electron mass ratio"         , value="1836.15"               , unit=nil                  }
Constants["Rbc"    ]	= {info="Rydberg constant"                   , value="1.0974 * 10^7"         , unit="m^-1"               }
Constants["C"      ]	= {info="Speed of light in vacuum"           , value="2.9979 * 10^8"         , unit="m/s"                }
Constants["q"      ]	= {info="e elementary charge"                , value="1.60218 * 10^-19"      , unit="C"                  }
Constants["pi"     ]	= {info="PI"                                 , value="pi"                    , unit=nil                  }
Constants[utf8(956).."0"]	= {info="Magnetic permeability constant" , value="4*pi*10^-7"            , unit=nil                  }
Constants[utf8(960)]	= Constants["pi"]

function checkIfExists(table, name)
    for k,v in pairs(table) do
        if (v.name == name) or (v == name) then -- lulz lua powa
            print("Conflict (i.e elements appearing twice) detected when loading Database. Skipping the item.")
            return true
        end
    end
    return false
end

function checkIfFormulaExists(table, formula)
    for k,v in pairs(table) do
        if (v.formula == formula)  then -- lulz lua powa
            print("Conflict (i.e formula appearing twice) detected when loading Database. Skipping formula.")
            return true
        end
    end
    return false
end

Categories	=	{}
Formulas	=	{}

function addCat(id,name,info)
    if checkIfExists(Categories, name) then
        print("Warning ! This category appears to exist already ! Adding anyway....")
    end
    return table.insert(Categories, id, {id=id, name=name, info=info, sub={}, varlink={}})
end

function addCatVar(cid, var, info, unit)
    Categories[cid].varlink[var] = {unit=unit, info=info }
end

function addSubCat(cid, id, name, info)
    if checkIfExists(Categories[cid].sub, name) then
        print("Warning ! This subcategory appears to exist already ! Adding anyway....")
    end
    return table.insert(Categories[cid].sub, id, {category=cid, id=id, name=name, info=info, formulas={}, variables={}})
end

function aF(cid, sid, formula, variables) --add Formula
	local fr	=	{category=cid, sub=sid, formula=formula, variables=variables}
	-- In times like this we are happy that inserting tables just inserts a reference

    -- commented out this check because only the subcategory duplicates should be avoided, and not on the whole db.
    --if not checkIfFormulaExists(Formulas, fr.formula) then
        table.insert(Formulas, fr)
    --end
    if not checkIfFormulaExists(Categories[cid].sub[sid].formulas, fr.formula) then
        table.insert(Categories[cid].sub[sid].formulas, fr)
    end
	
	-- This function might need to be merged with U(...)
	for variable,_ in pairs(variables) do
		Categories[cid].sub[sid].variables[variable]	= true
	end
end

function U(...)
	local out	= {}
	for i, p in ipairs({...}) do
		out[p]	= true
	end
	return out
end

----------------------------------------------
-- Categories && Sub-Categories && Formulas --
----------------------------------------------

c_O = utf8(963)
c_alpha = utf8(945)
c_beta = utf8(946)
c_gamma = utf8(947)
c_delta = utf8(948)
c_epsilon = utf8(949)
c_e = c_epsilon
c_Pi = utf8(960)
c_pi = c_Pi
c_mu = utf8(956)
c_tau = utf8(964)
c_rho = utf8(961)
c_phi = utf8(966)
c_omega = utf8(969)
c_CAPomega = utf8(937)
c_Ohm = c_CAPomega
c_theta = utf8(952)


--addCat(1, "Resistive Circuits", "Performs routine calculations of resistive circuits")
addCat(1, "Geometrie", "Dreiecke")

--addCatVar(1, "A", "Area", "m2")
addCatVar(1, "a", "Seitenl‰nge", "m")
addCatVar(1, "b", "Seitenl‰nge", "m")
addCatVar(1, "c", "Seitenl‰nge", "m")
addCatVar(1, c_alpha, "Winkel", "rad")
addCatVar(1, c_beta, "Winkel", "rad")
addCatVar(1, c_gamma, "Winkel", "rad")
addCatVar(1, "U", "Umfang", "m")
addCatVar(1, "r", "Radius", "m")
addCatVar(1, "d", "Durchmesser", "m")
addCatVar(1, "A", "Fl‰cheninhalt", "m2")

--addSubCat(1, 1, "Resistance Formulas", "")
addSubCat(1, 1, "Dreiecke", "")

--aF(1, 1, "R=("..c_rho.."*len)/A",U("R",c_rho,"len","A") )
aF(1, 1, "a/b=sin("..c_alpha..")/sin("..c_beta..")", U("a", "b", c_alpha, c_beta))
aF(1, 1, "a/c=sin("..c_alpha..")/sin("..c_gamma..")", U("a", "c", c_alpha, c_gamma))
aF(1, 1, "b/c=sin("..c_beta..")/sin("..c_gamma..")", U("b", "c", c_beta, c_gamma))
aF(1, 1, "a^2=b^2+c^2-2*b*c*cos("..c_alpha..")", U("a", "b", "c", c_alpha))
aF(1, 1, "b^2=a^2+c^2-2*a*c*cos("..c_beta..")", U("a", "b", "c", c_beta))
aF(1, 1, "c^2=b^2+a^2-2*b*a*cos("..c_gamma..")", U("a", "b", "c", c_gamma))

addSubCat(1, 2, "Kreise", "")

aF(1, 2, "U=d*"..c_pi, U("U", "d"))
aF(1, 2, "d=2*r", U("d", "r"))
aF(1, 2, "A=r^2*"..c_pi, U("A", "r"))


addCat(2, "Funktionen", "Parabeln")

addCatVar(2, "a", "Steigung", "")
addCatVar(2, "b", "", "")
addCatVar(2, "c", "", "")

addSubCat(2, 1, "Quadratische Funktionen", "")

-- This part is supposed to load external formulas stored in a string
-- (or else, if a better way of storing is found) from a file in MyLib.

function loadExtDB()
    local err
    _, err = pcall(function()
        loadstring(math.eval("formulaproextdb\\categories()"))()
        loadstring(math.eval("formulaproextdb\\variables()"))()
        loadstring(math.eval("formulaproextdb\\subcategories()"))()
        loadstring(math.eval("formulaproextdb\\equations()"))()
    end)

    if err then
        print("no external db loaded")
        -- Display something ?
        -- or it simply means there is nothing to be loaded.
    else
        -- display something that tells the user the external DB has been successfully loaded.
        print("external db succesfully loaded")
    end
end

local mathpi = math.pi

Units = {}

function Units.mainToSub(main, sub, n)
    local c = Units[main][sub]
    return n * c[1] + c[2]
end

function Units.subToMain(main, sub, n)
    local c = Units[main][sub]
    return (n - c[2]) / c[1]
end

--[[

Units["mainunit"]	= {}
Units["mainunit"]["subunit"]	= {a, b}

meaning: n mainunit = n*a+b subunit
or
n subunit = (n-b)/a mainunit

--]]


Mt = {}

Mt.G = 1 / 1000000000
Mt.M = 1 / 1000000
Mt.k = 1 / 1000
Mt.h = 1 / 100
Mt.da = 1 / 10
Mt.d = 10
Mt.c = 100
Mt.m = 1000
Mt.u = 1000000
Mt.n = 1000000000

Mt.us = utf8(956)


Units["W/K"] = {}
Units["W/K"]["kW/K"] = { Mt.k, 0 }
Units["W/K"]["mW/K"] = { Mt.m, 0 }

Units["1/" .. utf8(176) .. "K"] = {}

Units["m/s"] = {}
Units["m/s"]["km/s"] = { Mt.k, 0 }
Units["m/s"]["cm/s"] = { Mt.c, 0 }
Units["m/s"]["mm/s"] = { Mt.m, 0 }
Units["m/s"]["m/h"] = { 3600, 0 }
Units["m/s"]["km/h"] = { 3.6, 0 }


Units["m"] = {}
Units["m"]["km"] = { Mt.k, 0 }
Units["m"]["dm"] = { Mt.d, 0 }
Units["m"]["cm"] = { Mt.c, 0 }
Units["m"]["mm"] = { Mt.m, 0 }
Units["m"][Mt.us .. "m"] = { Mt.u, 0 }
Units["m"]["nm"] = { Mt.n, 0 }



-- these are actually the same type
Units["Hz"] = {}
Units["Hz"]["kHz"] = { Mt.k, 0 }
Units["Hz"]["MHz"] = { Mt.M, 0 }
Units["Hz"]["GHz"] = { Mt.G, 0 }

Units["rad/s"] = {}
Units["rad/s"]["RPM"] = { 1 / (2 * mathpi / 60), 0 }

Units["A/m"] = {}
Units["A/m"]["mA/m"] = { Mt.m, 0 }

Units["V/s"] = {}
Units["V/s"]["mV/s"] = { Mt.m, 0 }

Units["C/m"] = {}
Units["C/m"][Mt.us .. "C/m"] = { Mt.u, 0 }
Units["C/m"]["C/mm"] = { 1 / Mt.m, 0 }

Units["m2/s"] = {}

Units[utf8(937)] = {} --Ohm
Units[utf8(937)]["m" .. utf8(937)] = { Mt.m, 0 }
Units[utf8(937)]["k" .. utf8(937)] = { Mt.k, 0 }
Units[utf8(937)]["M" .. utf8(937)] = { Mt.M, 0 }

Units["s"] = {}
Units["s"]["ms"] = { Mt.m, 0 }
Units["s"][Mt.us .. "s"] = { Mt.u, 0 }
Units["s"]["ns"] = { Mt.n, 0 }

Units[utf8(937) .. "/m"] = {}
Units[utf8(937) .. "/m"][utf8(937) .. "/cm"] = { 1 / Mt.c, 0 }
Units[utf8(937) .. "/m"][utf8(937) .. "/mm"] = { 1 / Mt.m, 0 }

Units["1/m3"] = {}

Units["N"] = {}
Units["N"]["daN"] = { Mt.da, 0 }

Units["Wb"] = {}
Units["Wb"]["mWb"] = { Mt.m, 0 }

Units["A"] = {}
Units["A"]["kA"] = { Mt.k, 0 }
Units["A"]["mA"] = { Mt.m, 0 }
Units["A"][Mt.us .. "A"] = { Mt.u, 0 }

Units["S/m"] = {}
Units["S/m"]["mS/m"] = { Mt.m, 0 }
Units["S/m"]["S/mm"] = { 1 / Mt.m, 0 }

Units["C"] = {}
Units["C"]["mC"] = { Mt.m, 0 }
Units["C"][Mt.us .. "C"] = { Mt.u, 0 }

Units["m2/(V*s)"] = {}

Units["A/V2"] = {}
Units["A/V2"]["mA/V2"] = { Mt.m, 0 }


Units["N/m"] = {}
Units["N/m"]["daN"] = { Mt.da, 0 }

Units["rad"] = {}
Units["rad"]["degree"] = { 180 / mathpi, 0 }

Units["degree"] = {}
Units["degree"]["rad"] = { mathpi / 180, 0 }

Units["F"] = {}
Units["F"]["kF"] = { Mt.k, 0 }
Units["F"]["mF"] = { Mt.m, 0 }
Units["F"][Mt.us .. "F"] = { Mt.u, 0 }
Units["F"]["nF"] = { Mt.n, 0 }


Units[utf8(937) .. "*m"] = {}
Units[utf8(937) .. "*m"][utf8(937) .. "*cm"] = { Mt.c, 0 }
Units[utf8(937) .. "*m"][utf8(937) .. "*mm"] = { Mt.m, 0 }

Units["H"] = {}
Units["H"]["mH"] = { Mt.m, 0 }
Units["H"][Mt.us .. "H"] = { Mt.u, 0 }
Units["H"]["nH"] = { Mt.n, 0 }

Units["K"] = {}
Units["K"]["∞C"] = { 1, -273.15 }
Units["K"]["∞F"] = { 9 / 5, -459.67 }
Units["K"]["∞R"] = { 9 / 5, 0 }

Units["J"] = {}
Units["J"]["GJ"] = { Mt.G, 0 }
Units["J"]["MJ"] = { Mt.M, 0 }
Units["J"]["kJ"] = { Mt.k, 0 }
Units["J"]["kWh"] = { 1 / 3600000, 0 }

Units["1/V"] = {}

Units["F/m"] = {}
Units["F/m"]["F/cm"] = { 1 / Mt.c, 0 }
Units["F/m"]["F/mm"] = { 1 / Mt.m, 0 }
Units["F/m"][Mt.us .. "F/m"] = { Mt.u, 0 }

Units["V5"] = {}

Units["H/m"] = {}
Units["H/m"]["mH/m"] = { Mt.m, 0 }
Units["H/m"]["H/mm"] = { 1 / Mt.m, 0 }
Units["H/m"][Mt.us .. "H/m"] = { Mt.u, 0 }

Units["F/m2"] = {}
Units["F/m2"]["F/cm2"] = { 1 / Mt.c ^ 2, 0 }
Units["F/m2"]["mF/m2"] = { Mt.m, 0 }
Units["F/m2"][Mt.us .. "F/m2"] = { Mt.u, 0 }

Units["N*m"] = {}
Units["N*m"]["daN*m"] = { Mt.da, 0 }
Units["N*m"]["N*cm"] = { Mt.c, 0 }
Units["N*m"]["N*mm"] = { Mt.m, 0 }

Units["S"] = {}
Units["S"]["mS"] = { Mt.m, 0 }
Units["S"][Mt.us .. "S"] = { Mt.u, 0 }

Units["1/m4"] = {}

Units["A/(m2*K2)"] = {}

Units["T"] = {}
Units["T"]["mT"] = { Mt.m, 0 }
Units["T"][Mt.us .. "T"] = { Mt.u, 0 }
Units["T"]["nT"] = { Mt.n, 0 }

Units["W"] = {}
Units["W"]["GW"] = { Mt.G, 0 }
Units["W"]["MW"] = { Mt.M, 0 }
Units["W"]["kW"] = { Mt.k, 0 }
Units["W"]["mW"] = { Mt.m, 0 }
Units["W"][Mt.us .. "W"] = { Mt.u, 0 }

Units["V"] = {}
Units["V"]["MV"] = { Mt.M, 0 }
Units["V"]["kV"] = { Mt.k, 0 }
Units["V"]["mV"] = { Mt.m, 0 }
Units["V"][Mt.us .. "V"] = { Mt.u, 0 }

Units["m2"] = {}
Units["m2"]["cm2"] = { Mt.c ^ 2, 0 }
Units["m2"]["mm2"] = { Mt.m ^ 2, 0 }
Units["m2"]["km2"] = { Mt.k ^ 2, 0 }

Units["A/Wb"] = {}

Units["Pa"] = {}
Units["Pa"]["hPa"] = { Mt.h, 0 }
Units["Pa"]["bar"] = { 1 / 100000, 0 }
Units["Pa"]["atm"] = { 1.01325, 0 }

Units["1/K"] = {}

Units["V/m"] = {}
Units["V/m"]["mV/m"] = { Mt.m, 0 }
Units["V/m"]["V/mm"] = { 1 / Mt.m, 0 }
Units["V/m"]["V/cm"] = { 1 / Mt.c, 0 }

Units["C/m2"] = {}
Units["C/m2"]["mC/m2"] = { Mt.m, 0 }
Units["C/m2"][Mt.us .. "C/m2"] = { Mt.u, 0 }
------------------------------------------------------------------
--                  Overall Global Variables                    --
------------------------------------------------------------------
--
-- Uses BetterLuaAPI : https://github.com/adriweb/BetterLuaAPI-for-TI-Nspire
--

a_acute = string.uchar(225)
a_circ  = string.uchar(226)
a_tilde = string.uchar(227)
a_diaer = string.uchar(228)
a_ring  = string.uchar(229)
e_acute = string.uchar(233)
e_grave = string.uchar(232)
o_acute = string.uchar(243) 
o_circ  = string.uchar(244)
l_alpha = string.uchar(945)
l_beta = string.uchar(946)
l_omega = string.uchar(2126)
sup_plus = string.uchar(8314)
sup_minus = string.uchar(8315)
right_arrow = string.uchar(8594)


Color = {
	["black"] = {0, 0, 0},
	["red"] = {255, 0, 0},
	["green"] = {0, 255, 0},
	["blue "] = {0, 0, 255},
	["white"] = {255, 255, 255},
	["brown"] = {165,42,42},
	["cyan"] = {0,255,255},
	["darkblue"] = {0,0,139},
	["darkred"] = {139,0,0},
	["fuchsia"] = {255,0,255},
	["gold"] = {255,215,0},
	["gray"] = {127,127,127},
	["grey"] = {127,127,127},
	["lightblue"] = {173,216,230},
	["lightgreen"] = {144,238,144},
	["magenta"] = {255,0,255},
	["maroon"] = {128,0,0},
	["navyblue"] = {159,175,223},
	["orange"] = {255,165,0},
	["palegreen"] = {152,251,152},
	["pink"] = {255,192,203},
	["purple"] = {128,0,128},
	["royalblue"] = {65,105,225},
	["salmon"] = {250,128,114},
	["seagreen"] = {46,139,87},
	["silver"] = {192,192,192},
	["turquoise"] = {64,224,208},
	["violet"] = {238,130,238},
	["yellow"] = {255,255,0}
}
Color.mt = {__index = function () return {0,0,0} end}
setmetatable(Color,Color.mt)

function copyTable(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function deepcopy(t) -- This function recursively copies a table's contents, and ensures that metatables are preserved. That is, it will correctly clone a pure Lua object.
	if type(t) ~= 'table' then return t end
	local mt = getmetatable(t)
	local res = {}
	for k,v in pairs(t) do
		if type(v) == 'table' then
		v = deepcopy(v)
		end
	res[k] = v
	end
	setmetatable(res,mt)
	return res
end -- from http://snippets.luacode.org/snippets/Deep_copy_of_a_Lua_Table_2

function test(arg)
	return arg and 1 or 0
end

function screenRefresh()
	return platform.window:invalidate()
end

function pww()
	return platform.window:width()
end

function pwh()
	return platform.window:height()
end

function drawPoint(gc, x, y)
	gc:fillRect(x, y, 1, 1)
end

function drawCircle(gc, x, y, diameter)
	gc:drawArc(x - diameter/2, y - diameter/2, diameter,diameter,0,360)
end

function drawCenteredString(gc, str)
	gc:drawString(str, .5*(pww() - gc:getStringWidth(str)), .5*pwh(), "middle")
end

function drawXCenteredString(gc, str, y)
	gc:drawString(str, .5*(pww() - gc:getStringWidth(str)), y, "top")
end

function setColor(gc,theColor)
	if type(theColor) == "string" then
		theColor = string.lower(theColor)
		if type(Color[theColor]) == "table" then gc:setColorRGB(unpack(Color[theColor])) end
	elseif type(theColor) == "table" then
		gc:setColorRGB(unpack(theColor))
	end
end

function verticalBar(gc,x)
	gc:fillRect(gc,x,0,1,pwh())
end

function horizontalBar(gc,y)
	gc:fillRect(gc,0,y,pww(),1)
end

function nativeBar(gc, screen, y)
	gc:setColorRGB(128,128,128)
	gc:fillRect(screen.x+5, screen.y+y, screen.w-10, 2)
end

function drawSquare(gc,x,y,l)
	gc:drawPolyLine(gc,{(x-l/2),(y-l/2), (x+l/2),(y-l/2), (x+l/2),(y+l/2), (x-l/2),(y+l/2), (x-l/2),(y-l/2)})
end

function drawRoundRect(gc,x,y,wd,ht,rd)  -- wd = width, ht = height, rd = radius of the rounded corner
	x = x-wd/2  -- let the center of the square be the origin (x coord)
	y = y-ht/2 -- same for y coord
	if rd > ht/2 then rd = ht/2 end -- avoid drawing cool but unexpected shapes. This will draw a circle (max rd)
	gc:drawLine(x + rd, y, x + wd - (rd), y);
	gc:drawArc(x + wd - (rd*2), y + ht - (rd*2), rd*2, rd*2, 270, 90);
	gc:drawLine(x + wd, y + rd, x + wd, y + ht - (rd));
	gc:drawArc(x + wd - (rd*2), y, rd*2, rd*2,0,90);
	gc:drawLine(x + wd - (rd), y + ht, x + rd, y + ht);
	gc:drawArc(x, y, rd*2, rd*2, 90, 90);
	gc:drawLine(x, y + ht - (rd), x, y + rd);
	gc:drawArc(x, y + ht - (rd*2), rd*2, rd*2, 180, 90);
end

function fillRoundRect(gc,x,y,wd,ht,radius)  -- wd = width and ht = height -- renders badly when transparency (alpha) is not at maximum >< will re-code later
	if radius > ht/2 then radius = ht/2 end -- avoid drawing cool but unexpected shapes. This will draw a circle (max radius)
    gc:fillPolygon({(x-wd/2),(y-ht/2+radius), (x+wd/2),(y-ht/2+radius), (x+wd/2),(y+ht/2-radius), (x-wd/2),(y+ht/2-radius), (x-wd/2),(y-ht/2+radius)})
    gc:fillPolygon({(x-wd/2-radius+1),(y-ht/2), (x+wd/2-radius+1),(y-ht/2), (x+wd/2-radius+1),(y+ht/2), (x-wd/2+radius),(y+ht/2), (x-wd/2+radius),(y-ht/2)})
    x = x-wd/2  -- let the center of the square be the origin (x coord)
	y = y-ht/2 -- same
	gc:fillArc(x + wd - (radius*2), y + ht - (radius*2), radius*2, radius*2, 1, -91);
    gc:fillArc(x + wd - (radius*2), y, radius*2, radius*2,-2,91);
    gc:fillArc(x, y, radius*2, radius*2, 85, 95);
    gc:fillArc(x, y + ht - (radius*2), radius*2, radius*2, 180, 95);
end


-- Fullscreen 'Library'

doNotDisplayIcon = false

icon=image.new("\020\0\0\0\020\0\0\0\0\0\0\0\040\0\0\0\016\0\001\000wwwwwwwwwwwwww\223\251\222\251\189\251\188\251\188\251\221\255\221\255\254\255wwwwwwwwwwwwwwwwwwww\156\243\024\227\215\218\214\218\247\222\025\227Z\235\156\243wwwwwwwwwwwwwwwwwwwwww\024\227S\202s\206\181\214\214\218\248\2229\2279\231Z\235Z\235wwwwwwwwwwwwwwwwwwZ\235\207\185\016\194R\202s\206\148\210\214\218\214\218\214\2229\231Z\235:\231wwwwwwwwwwwwww\190\251\239\189\239\189\148\210\148\210\156\247\148\214\214\218\147\210\181\218{\239\025\227Z\235|\239wwwwwwwwwwww\149\214\239\189\239\189\239\189\206\185{\239\206\185R\202R\202\148\214{\239\247\2229\227Z\231wwwwwwwwww\189\255\016\194\239\189\239\189\239\189\206\185{\239\173\181\016\194\016\194s\210Z\235\214\218\247\222\025\227\189\247wwwwwwww8\243\016\194\239\189\239\189\240\189\206\189{\239\206\185\016\194\207\185s\2109\235\148\210\214\218\024\223{\239wwwwww\254\255\244\238\239\189\206\185\207\185\206\185\140\177z\239\008\161\008\161\198\152\016\194\214\218\173\181\017\194t\206:\231wwwwww\188\2556\247\016\194\206\185k\173)\165\231\156{\239\132\144\133\144c\140\239\193\148\210\008\161l\173\239\1899\231wwwwwwx\255\154\255\240\189\231\156\132\144C\136B\136k\173\0\128B\136!\132\165\148\231\156B\136\165\148K\173\156\243wwwwww6\255\154\255\024\227\198\152c\140\206\185\206\185\173\181\207\185k\173)\165\206\185\239\189J\169c\140\173\181\222\251wwwwww6\255x\255ww\140\177\0\128\148\210\016\194\173\181R\202\173\181\206\185R\202\239\189\231\156\164\152\213\218wwwwwwwwx\2556\255ww\222\251J\169\008\161c\140c\140c\140c\140c\140c\140\008\169O\230o\234\178\242z\251wwwwww\221\255\209\250wwwwww\239\189\132\144d\140B\136d\140\132\144B\136\202\213\012\234\012\230\012\230-\234\189\251wwwwww\242\2506\255wwwwww\156\243\149\210\016\194\240\1892\202\247\222\236\221\147\222r\2220\214\146\222\245\238wwwwww\188\255\141\250\243\250wwwwwwwwwwwwww\021\251\168\221\136\217\169\213\236\213O\222Y\243wwwwwwww\188\255\142\250m\250\244\250X\255y\2557\255\177\250)\246(\246K\242\168\229\134\229\134\229\178\238wwwwwwwwwwwwwwW\255\175\250k\250J\250K\250\141\250\242\250y\255ww\188\2557\251z\251wwwwwwwwwwwwwwwwwwww\222\255\222\255\222\255wwwwwwwwwwwwwwwwwwwwww")

local pw	= getmetatable(platform.window)
function pw:invalidateAll()
	if self.setFocus then
		self:setFocus(false)
		self:setFocus(true)
	end
end

function on.draw(gc)
	gc:setColorRGB(255, 255, 255)
	gc:fillRect(18, 5, 20, 20)
	gc:drawImage(icon, 18, 5)
end

if not platform.withGC then
    function platform.withGC(func, ...)
        local gc = platform.gc()
        gc:begin()
        func(..., gc)
        gc:finish()
    end
end


----------

local tstart = timer.start
function timer.start(ms)
    if not timer.isRunning then
        tstart(ms)
    end
    timer.isRunning = true
end

local tstop = timer.stop
function timer.stop()
    timer.isRunning = false
    tstop()
end


if platform.hw then
    timer.multiplier = platform.hw() < 4 and 3.2 or 1
else
    timer.multiplier = platform.isDeviceModeRendering() and 3.2 or 1
end

function on.timer()
    --current_screen():timer()
    local j = 1
    while j <= #timer.tasks do -- for each task
        if timer.tasks[j][2]() then -- delete it if has ended
            table.remove(timer.tasks, j)
            sj = j - 1
        end
        j = j + 1
    end
    if #timer.tasks > 0 then
        platform.window:invalidate()
    else
        --for _,screen in pairs(Screens) do
        --	screen:size()
        --end
        timer.stop()
    end
end

timer.tasks = {}

timer.addTask = function(object, task) timer.start(0.01) table.insert(timer.tasks, { object, task }) end

function timer.purgeTasks(object)
    local j = 1
    while j <= #timer.tasks do
        if timer.tasks[j][1] == object then
            table.remove(timer.tasks, j)
            j = j - 1
        end
        j = j + 1
    end
end


---------- Animable Object class
Object = class()
function Object:init(x, y, w, h, r)
    self.tasks = {}
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = r
    self.visible = true
end

function Object:PushTask(task, t, ms, callback)
    table.insert(self.tasks, { task, t, ms, callback })
    timer.start(0.01)
    if #self.tasks == 1 then
        local ok = task(self, t, ms, callback)
        if not ok then table.remove(self.tasks, 1) end
    end
end

function Object:PopTask()
    table.remove(self.tasks, 1)
    if #self.tasks > 0 then
        local task, t, ms, callback = unpack(self.tasks[1])
        local ok = task(self, t, ms, callback)
        if not ok then table.remove(self.tasks, 1) end
    end
end

function Object:purgeTasks()
    for i = 1, #self.tasks do
        self.tasks[i] = nil
    end
    collectgarbage()
    timer.purgeTasks(self)
    self.tasks = {}
    return self
end

function Object:paint(gc)
    -- to override
end

speed = 1

function Object:__Animate(t, ms, callback)
    if not ms then ms = 50 end
    if ms < 0 then print("Error: Invalid time divisor (must be >= 0)") return end
    ms = ms / timer.multiplier
    if ms == 0 then ms = 1 end
    if not t or type(t) ~= "table" then print("Error: Target position is " .. type(t)) return end
    if not t.x then t.x = self.x end
    if not t.y then t.y = self.y end
    if not t.w then t.w = self.w end
    if not t.h then t.h = self.h end
    if not t.r then t.r = self.r else t.r = math.pi * t.r / 180 end
    local xinc = (t.x - self.x) / ms
    local xside = xinc >= 0 and 1 or -1
    local yinc = (t.y - self.y) / ms
    local yside = yinc >= 0 and 1 or -1
    local winc = (t.w - self.w) / ms
    local wside = winc >= 0 and 1 or -1
    local hinc = (t.h - self.h) / ms
    local hside = hinc >= 0 and 1 or -1
    local rinc = (t.r - self.r) / ms
    local rside = rinc >= 0 and 1 or -1
    timer.addTask(self, function()
        local b1, b2, b3, b4, b5 = false, false, false, false, false
        if (self.x + xinc * speed) * xside < t.x * xside then self.x = self.x + xinc * speed else b1 = true end
        if self.y * yside < t.y * yside then self.y = self.y + yinc * speed else b2 = true end
        if self.w * wside < t.w * wside then self.w = self.w + winc * speed else b3 = true end
        if self.h * hside < t.h * hside then self.h = self.h + hinc * speed else b4 = true end
        if self.r * rside < t.r * rside then self.r = self.r + rinc * speed else b5 = true end
        if self.w < 0 then self.w = 0 end
        if self.h < 0 then self.h = 0 end
        if b1 and b2 and b3 and b4 and b5 then
            self.x, self.y, self.w, self.h, self.r = t.x, t.y, t.w, t.h, t.r
            self:PopTask()
            if callback then callback(self) end
            return true
        end
        return false
    end)
    return true
end

function Object:__Delay(_, ms, callback)
    if not ms then ms = 50 end
    if ms < 0 then print("Error: Invalid time divisor (must be >= 0)") return end
    ms = ms / timer.multiplier
    if ms == 0 then ms = 1 end
    local t = 0
    timer.addTask(self, function()
        if t < ms then
            t = t + 1
            return false
        else
            self:PopTask()
            if callback then callback(self) end
            return true
        end
    end)
    return true
end

function Object:__setVisible(t, _, _)
    timer.addTask(self, function()
        self.visible = t
        self:PopTask()
        return true
    end)
    return true
end

function Object:Animate(t, ms, callback)
    self:PushTask(self.__Animate, t, ms, callback)
    return self
end

function Object:Delay(ms, callback)
    self:PushTask(self.__Delay, false, ms, callback)
    return self
end

function Object:setVisible(t)
    self:PushTask(self.__setVisible, t, 1, false)
    return self
end


stdout	= print

function pprint(...)
	stdout(...)
	local out	= ""
	for _,v in ipairs({...}) do 
		out	=	out .. (_==1 and "" or "    ") .. tostring(v)
	end
	var.store("print", out)
end


function Pr(n, d, s, ex)
	local nc	= tonumber(n)
	if nc and nc<math.abs(nc) then
		return s-ex-(type(n)== "number" and math.abs(n) or (.01*s*math.abs(nc)))
	else
		return (type(n)=="number" and n or (type(n)=="string" and .01*s*nc or d))
	end
end

-- Apply an extension on a class, and return our new frankenstein 
function addExtension(oldclass, extension)
	local newclass	= class(oldclass)
	for key, data in pairs(extension) do
		newclass[key]	= data
	end
	return newclass
end

clipRectData	= {}

function gc_clipRect(gc, what, x, y, w, h)
	if what == "set" and clipRectData.current then
		clipRectData.old	= clipRectData.current
		
	elseif what == "subset" and clipRectData.current then
		clipRectData.old	= clipRectData.current
		x	= clipRectData.old.x<x and x or clipRectData.old.x
		y	= clipRectData.old.y<y and y or clipRectData.old.y
		h	= clipRectData.old.y+clipRectData.old.h > y+h and h or clipRectData.old.y+clipRectData.old.h-y
		w	= clipRectData.old.x+clipRectData.old.w > x+w and w or clipRectData.old.x+clipRectData.old.w-x
		what = "set"
		
	elseif what == "restore" and clipRectData.old then
		--gc:clipRect("reset")
		what = "set"
		x	= clipRectData.old.x
		y	= clipRectData.old.y
		h	= clipRectData.old.h
		w	= clipRectData.old.w
	elseif what == "restore" then
		what = "reset"
	end
	
	gc:clipRect(what, x, y, w, h)
	if x and y and w and h then clipRectData.current = {x=x,y=y,w=w,h=h} end
end

------------------------------------------------------------------
--                        Screen  Class                         --
------------------------------------------------------------------

Screen	=	class(Object)

Screens	=	{}

function scrollScreen(screen, d, callback)
  --  print("scrollScreen.  number of screens : ", #Screens)
    local dir = d or 1
    screen.x=dir*kXSize
    screen:Animate( {x=0}, 10, callback )
end

function insertScreen(screen, ...)
  --  print("insertScreen")
	screen:size()
    if current_screen() ~= DummyScreen then
        current_screen():screenLoseFocus()
        local coeff = pushFromBack and 1 or -1
	    current_screen():Animate( {x=coeff*kXSize}, 10)
    end
	table.insert(Screens, screen)

	platform.window:invalidate()
	current_screen():pushed(...)
end

function insertScreen_direct(screen, ...)
  --  print("insertScreen_direct")
	screen:size()
	table.insert(Screens, screen)
	platform.window:invalidate()
	current_screen():pushed(...)
end

function push_screen(screen, ...)
    --print("push_screen")
    local args = ...
    local theScreen = current_screen()
    pushFromBack = false
    insertScreen(screen, ...)
    scrollScreen(screen, 1, function() remove_screen_previous(theScreen) end)
end

function push_screen_back(screen, ...)
    --print("push_screen_back")
    local theScreen = current_screen()
    pushFromBack = true
    insertScreen(screen, ...)
    scrollScreen(screen, -1, function() remove_screen_previous(theScreen) end)
end

function push_screen_direct(screen, ...)
   -- print("push_screen_direct")
	table.insert(Screens, screen)
	platform.window:invalidate()
	current_screen():pushed(...)
end

function only_screen(screen, ...)
   -- print("only_screen")
    remove_screen(current_screen())
	Screens	=	{}
	push_screen(screen, ...)
	platform.window:invalidate()
end

function only_screen_back(screen, ...)
 --   print("only_screen_back")
    --Screens	=	{}
	push_screen_back(screen, ...)
	platform.window:invalidate()
end

function remove_screen_previous(...)
  --  print("remove_screen_previous")
	platform.window:invalidate()
	current_screen():removed(...)
	res=table.remove(Screens, #Screens-1)
	current_screen():screenGetFocus()
	return res
end

function remove_screen(...)
  --  print("remove_screen")
	platform.window:invalidate()
	current_screen():removed(...)
	res=table.remove(Screens)
	current_screen():screenGetFocus()
	return res
end

function current_screen()
	return Screens[#Screens] or DummyScreen
end

function Screen:init(xx,yy,ww,hh)

	self.yy	=	yy
	self.xx	=	xx
	self.hh	=	hh
	self.ww	=	ww
	
	self:ext()
	self:size(0)
	
	Object.init(self, self.x, self.y, self.w, self.h, 0)
end

function Screen:ext()
end

function Screen:size()
	local screenH	=	platform.window:height()
	local screenW	=	platform.window:width()

	if screenH	== 0 then screenH=212 end
	if screenW	== 0 then screenW=318 end

	self.x	=	math.floor(Pr(self.xx, 0, screenW)+.5)
	self.y	=	math.floor(Pr(self.yy, 0, screenH)+.5)
	self.w	=	math.floor(Pr(self.ww, screenW, screenW, 0)+.5)
	self.h	=	math.floor(Pr(self.hh, screenH, screenH, 0)+.5)
end


function Screen:pushed() end
function Screen:removed() end
function Screen:screenLoseFocus() end
function Screen:screenGetFocus() end

function Screen:draw(gc)
	--self:size()
	self:paint(gc)
end

function Screen:paint(gc) end

function Screen:invalidate()
	platform.window:invalidate(self.x ,self.y , self.w, self.h)
end

function Screen:arrowKey()	end
function Screen:enterKey()	end
function Screen:backspaceKey()	end
function Screen:clearKey() 	end
function Screen:escapeKey()	end
function Screen:tabKey()	end
function Screen:backtabKey()	end
function Screen:charIn(char)	end


function Screen:mouseDown()	end
function Screen:mouseUp()	end
function Screen:mouseMove()	end
function Screen:contextMenu()	end

function Screen:appended() end

function Screen:resize(w,h) end

function Screen:destroy()
	self	= nil
end

------------------------------------------------------------------
--                   WidgetManager Extension                    --
------------------------------------------------------------------

WidgetManager	= {}

function WidgetManager:ext()
	self.widgets	=	{}
	self.focus	=	0
end

function WidgetManager:resize(w,h)
    if self.x then  --already inited
        self:size()
    end
end

function WidgetManager:appendWidget(widget, xx, yy) 
	widget.xx	=	xx
	widget.yy	=	yy
	widget.parent	=	self
	widget:size()
	
	table.insert(self.widgets, widget)
	widget.pid	=	#self.widgets
	
	widget:appended(self)
	return self
end

function WidgetManager:getWidget()
	return self.widgets[self.focus]
end

function WidgetManager:drawWidgets(gc) 
	for _, widget in pairs(self.widgets) do
		widget:size()
		widget:draw(gc)
		
		gc:setColorRGB(0,0,0)
	end
end

function WidgetManager:postPaint(gc) 
end

function WidgetManager:draw(gc)
	--self:size()
	self:paint(gc)
	self:drawWidgets(gc)
	self:postPaint(gc)
end


function WidgetManager:loop(n) end

function WidgetManager:stealFocus(n)
	local oldfocus=self.focus
	if oldfocus~=0 then
		local veto	= self:getWidget():loseFocus(n)
		if veto == -1 then
			return -1, oldfocus
		end
		self:getWidget().hasFocus	=	false
		self.focus	= 0
	end
	return 0, oldfocus
end

function WidgetManager:focusChange() end

function WidgetManager:switchFocus(n, b)
	if n~=0 and #self.widgets>0 then
		local veto, focus	= self:stealFocus(n)
		if veto == -1 then
			return -1
		end
		
		local looped
		self.focus	=	focus + n
		if self.focus>#self.widgets then
			self.focus	=	1
			looped	= true
		elseif self.focus<1 then
			self.focus	=	#self.widgets
			looped	= true
		end	
		if looped and self.noloop and not b then
			self.focus	= focus
			self:loop(n)
		else
			self:getWidget().hasFocus	=	true	
			self:getWidget():getFocus(n)
		end
	end
	self:focusChange()
end


function WidgetManager:arrowKey(arrow)	
	if self.focus~=0 then
		self:getWidget():arrowKey(arrow)
	end
	self:invalidate()
end

function WidgetManager:enterKey()
    if self.focus~=0 then
        self:getWidget():enterKey()
    else
        if self.widgets and self.widgets[1] then   -- ugh, quite a bad hack for the mouseUp at (0,0) when cursor isn't shown (grrr TI) :/
            self.widgets[1]:enterKey()
        end
    end
    self:invalidate()
end

function WidgetManager:clearKey()	
	if self.focus~=0 then
		self:getWidget():clearKey()
	end
	self:invalidate()
end

function WidgetManager:backspaceKey()
	if self.focus~=0 then
		self:getWidget():backspaceKey()
	end
	self:invalidate()
end

function WidgetManager:escapeKey()	
	if self.focus~=0 then
		self:getWidget():escapeKey()
	end
	self:invalidate()
end

function WidgetManager:tabKey()	
	self:switchFocus(1)
	self:invalidate()
end

function WidgetManager:backtabKey()	
	self:switchFocus(-1)
	self:invalidate()
end

function WidgetManager:charIn(char)
	if self.focus~=0 then
		self:getWidget():charIn(char)
	end
	self:invalidate()
end

function WidgetManager:getWidgetIn(x, y)
	for n, widget in pairs(self.widgets) do
		local wox	= widget.ox or 0
		local woy	= widget.oy or 0
		if x>=widget.x-wox and y>=widget.y-wox and x<widget.x+widget.w-wox and y<widget.y+widget.h-woy then
			return n, widget
		end
	end 
end

function WidgetManager:mouseDown(x, y) 
	local n, widget	=	self:getWidgetIn(x, y)
	if n then
		if self.focus~=0 and self.focus~=n then self:getWidget().hasFocus = false self:getWidget():loseFocus()  end
		self.focus	=	n
		
		widget.hasFocus	=	true
		widget:getFocus()

		widget:mouseDown(x, y)
		self:focusChange()
	else
		if self.focus~=0 then self:getWidget().hasFocus = false self:getWidget():loseFocus() end
		self.focus	=	0
	end
end

function WidgetManager:mouseUp(x, y)
    if self.focus~=0 then
        --self:getWidget():mouseUp(x, y)
    end
    for _, widget in pairs(self.widgets) do
        widget:mouseUp(x,y) -- well, mouseUp is a release of a button, so everything previously "clicked" should be released, for every widget, even if the mouse has moved (and thus changed widget)
        -- eventually, a better way for this would be to keep track of the last widget active and do it to this one only...
    end
    self:invalidate()
end

function WidgetManager:mouseMove(x, y)
	if self.focus~=0 then
		self:getWidget():mouseMove(x, y)
	end
end



--------------------------
-- Our new frankenstein --
--------------------------

WScreen	= addExtension(Screen, WidgetManager)

--Dialog screen

Dialog	=	class(WScreen)

function Dialog:init(title,xx,yy,ww,hh)

	self.yy	=	yy
	self.xx	=	xx
	self.hh	=	hh
	self.ww	=	ww
	self.title	=	title
	self:size()
	
	self.widgets	=	{}
	self.focus	=	0
	    
end

function Dialog:paint(gc)
	self.xx	= (pww()-self.w)/2
	self.yy	= (pwh()-self.h)/2
	self.x, self.y	= self.xx, self.yy
	
	gc:setFont("sansserif","r",10)
	gc:setColorRGB(224,224,224)
	gc:fillRect(self.x, self.y, self.w, self.h)

	for i=1, 14,2 do
		gc:setColorRGB(32+i*3, 32+i*4, 32+i*3)
		gc:fillRect(self.x, self.y+i, self.w,2)
	end
	gc:setColorRGB(32+16*3, 32+16*4, 32+16*3)
	gc:fillRect(self.x, self.y+15, self.w, 10)
	
	gc:setColorRGB(128,128,128)
	gc:drawRect(self.x, self.y, self.w, self.h)
	gc:drawRect(self.x-1, self.y-1, self.w+2, self.h+2)
	
	gc:setColorRGB(96,100,96)
	gc:fillRect(self.x+self.w+1, self.y, 1, self.h+2)
	gc:fillRect(self.x, self.y+self.h+2, self.w+3, 1)
	
	gc:setColorRGB(104,108,104)
	gc:fillRect(self.x+self.w+2, self.y+1, 1, self.h+2)
	gc:fillRect(self.x+1, self.y+self.h+3, self.w+3, 1)
	gc:fillRect(self.x+self.w+3, self.y+2, 1, self.h+2)
	gc:fillRect(self.x+2, self.y+self.h+4, self.w+2, 1)
			
	gc:setColorRGB(255,255,255)
	gc:drawString(self.title, self.x + 4, self.y+2, "top")
	
	self:postPaint(gc)
end

function Dialog:postPaint() end



---
-- The dummy screen
---

DummyScreen	= Screen()


------------------------------------------------------------------
--                   Bindings to the on events                  --
------------------------------------------------------------------


function on.paint(gc)	
    allWentWell, generalErrMsg = pcall(onpaint, gc)
    if not allWentWell and errorHandler then
        errorHandler.display = true
        errorHandler.errorMessage = generalErrMsg
    end
    if platform.hw and platform.hw() < 4 and not doNotDisplayIcon then 
    	platform.withGC(on.draw)
    end
end

function onpaint(gc)
	for _, screen in pairs(Screens) do
		screen:draw(gc)	
	end
	if errorHandler.display then
	    errorPopup(gc)
	end
end

function on.resize(w, h)
	-- Global Ratio Constants for On-Calc (shouldn't be used often though...)
	kXRatio = w/320
	kYRatio = h/212
	
	kXSize, kYSize = w, h
	
	for _,screen in pairs(Screens) do
		screen:resize(w,h)
	end

	-- No better place?
	toolpalette.enableCopy(true)
	toolpalette.enablePaste(true)
end

function on.arrowKey(arrw)	current_screen():arrowKey(arrw)  end
function on.enterKey()		current_screen():enterKey()		 end
function on.escapeKey()		current_screen():escapeKey()	 end
function on.tabKey()		current_screen():tabKey()		 end
function on.backtabKey()	current_screen():backtabKey()	 end
function on.charIn(ch)		current_screen():charIn(ch)		 end
function on.backspaceKey()	current_screen():backspaceKey()  end
function on.contextMenu()	current_screen():contextMenu()   end
function on.mouseDown(x,y)	current_screen():mouseDown(x,y)	 end
function on.mouseUp(x,y)	if (x == 0 and y == 0) then current_screen():enterKey() else current_screen():mouseUp(x,y) end	 end
function on.mouseMove(x,y)	current_screen():mouseMove(x,y)  end
function on.clearKey()    	current_screen():clearKey()      end
function uCol(col)
	return col[1] or 0, col[2] or 0, col[3] or 0
end

function textLim(gc, text, max)
	local ttext, out = "",""
	local width	= gc:getStringWidth(text)
	if width<max then
		return text, width
	else
		for i=1, #text do
			ttext	= text:usub(1, i)
			if gc:getStringWidth(ttext .. "..")>max then
				break
			end
			out = ttext
		end
		return out .. "..", gc:getStringWidth(out .. "..")
	end
end


------------------------------------------------------------------
--                        Widget  Class                         --
------------------------------------------------------------------

Widget	=	class(Screen)

function Widget:init()
	self.dw	=	10
	self.dh	=	10
	
	self:ext()
end

function Widget:setSize(w, h)
	self.ww	= w or self.ww
	self.hh	= h or self.hh
end

function Widget:setPos(x, y)
	self.xx	= x or self.xx
	self.yy	= y or self.yy
end

function Widget:size(n)
	if n then return end
	self.w	=	math.floor(Pr(self.ww, self.dw, self.parent.w, 0)+.5)
	self.h	=	math.floor(Pr(self.hh, self.dh, self.parent.h, 0)+.5)
	
	self.rx	=	math.floor(Pr(self.xx, 0, self.parent.w, self.w)+.5)
	self.ry	=	math.floor(Pr(self.yy, 0, self.parent.h, self.h)+.5)
	self.x	=	self.parent.x + self.rx
	self.y	=	self.parent.y + self.ry
end

function Widget:giveFocus()
	if self.parent.focus~=0 then
		local veto	= self.parent:stealFocus()
		if veto == -1 then
			return -1
		end		
	end
	
	self.hasFocus	=	true
	self.parent.focus	=	self.pid
	self:getFocus()
end

function Widget:getFocus() end
function Widget:loseFocus() end
function Widget:clearKey() 	end

function Widget:enterKey() 
	self.parent:switchFocus(1)
end
function Widget:arrowKey(arrow)
	if arrow=="up" then 
		self.parent:switchFocus(self.focusUp or -1)
	elseif arrow=="down"  then
		self.parent:switchFocus(self.focusDown or 1)
	elseif arrow=="left" then 
		self.parent:switchFocus(self.focusLeft or -1)
	elseif arrow=="right"  then
		self.parent:switchFocus(self.focusRight or 1)	
	end
end


WWidget	= addExtension(Widget, WidgetManager)


------------------------------------------------------------------
--                        Sample Widget                         --
------------------------------------------------------------------

-- First, create a new class based on Widget
box	=	class(Widget)

-- Init. You should define self.dh and self.dw, in case the user doesn't supply correct width/height values.
-- self.ww and self.hh can be a number or a string. If it's a number, the width will be that amount of pixels.
-- If it's a string, it will be interpreted as % of the parent screen size.
-- These values will be used to calculate self.w and self.h (don't write to this, it will overwritten everytime the widget get's painted)
-- self.xx and self.yy will be set when appending the widget to a screen. This value support the same % method (in a string)
-- They will be used to calculate self.x and self.h 
function box:init(ww,hh,t)
	self.dh	= 10
	self.dw	= 10
	self.ww	= ww
	self.hh	= hh
	self.t	= t
end

-- Paint. Here you can paint your widget stuff
-- Variable you can use:
-- self.x, self.y	: numbers, x and y coordinates of the widget relative to screen. So it's the actual pixel position on the screen.
-- self.w, self.h	: numbers, w and h of widget
-- many others

function box:paint(gc)
	gc:setColorRGB(0,0,0)
	
	-- Do I have focus?
	if self.hasFocus then
		-- Yes, draw a filled black square
		gc:fillRect(self.x, self.y, self.w, self.h)
	else
		-- No, draw only the outline
		gc:drawRect(self.x, self.y, self.w, self.h)
	end
	
	gc:setColorRGB(128,128,128)
	if self.t then
		gc:drawString(self.t,self.x+2,self.y+2,"top")
	end
end


------------------------------------------------------------------
--                         Input Widget                         --
------------------------------------------------------------------


sInput	=	class(Widget)

function sInput:init(width)
	self.dw	=	width
	self.dh	=	20
	
	self.value	=	""	
	self.bgcolor	=	{255,255,255}
    self.focuscolor = platform.isColorDisplay() and {40,148,184} or {0,0,0}
	self.disabledcolor	= {128,128,128}
	self.font	=	{"sansserif", "r", 10}
	self.disabled	= false
end

function sInput:paint(gc)
	self.gc	=	gc
	local x	=	self.x
	local y = 	self.y
	
	gc:setFont(uCol(self.font))
	gc:setColorRGB(uCol(self.bgcolor))
	gc:fillRect(x, y, self.w, self.h)

	gc:setColorRGB(0,0,0)
	gc:drawRect(x, y, self.w, self.h)
	
	if self.hasFocus then
        gc:setColorRGB(uCol(self.focuscolor))
        gc:drawRect(x-1, y-1, self.w+2, self.h+2)
        gc:setColorRGB(0, 0, 0)
    end
		
	local text	=	self.value
	local	p	=	0
	
	
	gc_clipRect(gc, "subset", x, y, self.w, self.h)
	
	--[[
	while true do
		if p==#self.value then break end
		p	=	p + 1
		text	=	self.value:sub(-p, -p) .. text
		if gc:getStringWidth(text) > (self.w - 8) then
			text	=	text:sub(2,-1)
			break 
		end
	end
	--]]
	
	if self.disabled or self.value == "" then
		gc:setColorRGB(uCol(self.disabledcolor))
	end
	if self.value == ""  then
		text	= self.placeholder or ""
	end
	
	local strwidth = gc:getStringWidth(text)
	
	if strwidth<self.w-4 or not self.hasFocus then
		gc:drawString(text, x+2, y+1, "top")
	else
		gc:drawString(text, x-4+self.w-strwidth, y+1, "top")
	end
	
	if self.hasFocus and self.value ~= "" then
		gc:fillRect(self.x+(text==self.value and strwidth+2 or self.w-4), self.y, 1, self.h)
	end
	
	gc_clipRect(gc, "restore")
end

function sInput:charIn(char)
	if self.disabled or (self.number and not tonumber(self.value .. char)) then --or char~="," then
		return
	end
	--char = (char == ",") and "." or char
	self.value	=	self.value .. char
end

function sInput:clearKey()
    if self:deleteInvalid() then return 0 end
    self.value	=	""
end

function sInput:backspaceKey()
    if self:deleteInvalid() then return 0 end
	if not self.disabled then
		self.value	=	self.value:usub(1,-2)
	end
end

function sInput:deleteInvalid()
    local isInvalid = string.find(self.value, "Invalid input")
    if isInvalid then
        self.value = self.value:usub(1, -19)
        return true
    end
    return false
end

function sInput:enable()
	self.disabled	= false
end

function sInput:disable()
	self.disabled	= true
end




------------------------------------------------------------------
--                         Label Widget                         --
------------------------------------------------------------------

sLabel	=	class(Widget)

function sLabel:init(text, widget)
	self.widget	=	widget
	self.text	=	text
	self.ww		=	30
	
	self.hh		=	20
	self.lim	=	false
	self.color	=	{0,0,0}
	self.font	=	{"sansserif", "r", 10}
	self.p		=	"top"
	
end

function sLabel:paint(gc)
	gc:setFont(uCol(self.font))
	gc:setColorRGB(uCol(self.color))
	
	local text	=	""
	local ttext
	if self.lim then
		text, self.dw	= textLim(gc, self.text, self.w)
	else
		text = self.text
	end
	
	gc:drawString(text, self.x, self.y, self.p)
end

function sLabel:getFocus(n)
	if n then
		n	= n < 0 and -1 or (n > 0 and 1 or 0)
	end
	
	if self.widget and not n then
		self.widget:giveFocus()
	elseif n then
		self.parent:switchFocus(n)
	end
end


------------------------------------------------------------------
--                        Button Widget                         --
------------------------------------------------------------------

sButton	=	class(Widget)

function sButton:init(text, action)
    self.text	=	text
    self.action	=	action
    self.pushed = false

    self.dh	=	27
    self.dw	=	48

    self.bordercolor = platform.isColorDisplay() and {136,136,136} or {160,160,160}
    self.focuscolor = platform.isColorDisplay() and {40,148,184} or {0,0,0}
    self.font = {"sansserif", "r", 10}
end

function sButton:paint(gc)
    gc:setFont(uCol(self.font))
    self.ww	=	gc:getStringWidth(self.text)+10
    self:size()

    if self.pushed and self.forcePushed then
        self.y = self.y + 2
    end

    gc:setColorRGB(248,252,248)
    gc:fillRect(self.x+2, self.y+2, self.w-4, self.h-4)
    gc:setColorRGB(0,0,0)

    gc:drawString(self.text, self.x+5, self.y+3, "top")

    if self.hasFocus then
        gc:setColorRGB(uCol(self.focuscolor))
        gc:setPen("medium", "smooth")
    else
        gc:setColorRGB(uCol(self.bordercolor))
        gc:setPen("thin", "smooth")
    end
    gc:fillRect(self.x + 2, self.y, self.w-4, 2)
    gc:fillRect(self.x + 2, self.y+self.h-2, self.w-4, 2)
    gc:fillRect(self.x, self.y+2, 1, self.h-4)
    gc:fillRect(self.x+1, self.y+1, 1, self.h-2)
    gc:fillRect(self.x+self.w-1, self.y+2, 1, self.h-4)
    gc:fillRect(self.x+self.w-2, self.y+1, 1, self.h-2)

    if self.hasFocus then
        gc:setColorRGB(uCol(self.focuscolor))
        -- old way of indicating focus :
        -- gc:drawRect(self.x-2, self.y-2, self.w+3, self.h+3)
        -- gc:drawRect(self.x-3, self.y-3, self.w+5, self.h+5)
    end
end

function sButton:mouseMove(x,y)
    local isIn = (x>self.x and x<(self.x+self.w) and y>self.y and y<(self.y+self.h))
    self.pushed = self.forcePushed and isIn
    platform.window:invalidate()
end

function sButton:enterKey()
    if self.action then self.action() end
end

function sButton:mouseDown(x,y)
    if (x>self.x and x<(self.x+self.w) and y>self.y and y<(self.y+self.h)) then
        self.pushed = true
        self.forcePushed = true
    end
    platform.window:invalidate()
end

function sButton:mouseUp(x,y)
    self.pushed = false
    self.forcePushed = false
    if (x>self.x and x<(self.x+self.w) and y>self.y and y<(self.y+self.h)) then
        self:enterKey()
    end
    platform.window:invalidate()
end


------------------------------------------------------------------
--                      Scrollbar Widget                        --
------------------------------------------------------------------


scrollBar	= class(Widget)

scrollBar.upButton=image.new("\011\0\0\0\010\0\0\0\0\0\0\0\022\0\0\0\016\0\001\0001\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\198\255\255\255\255\255\255\255\255\156\243\255\255\255\255\255\255\255\2551\1981\198\255\255\255\255\255\255\214\218\0\128\214\218\255\255\255\255\255\2551\1981\198\255\255\255\255\247\222B\136\0\128B\136\247\222\255\255\255\2551\1981\198\255\255\247\222B\136!\132\0\128!\132B\136\247\222\255\2551\1981\198\247\222B\136!\132B\136R\202B\136!\132B\136\247\2221\1981\198\132\144B\136B\136\247\222\255\255\247\222B\136B\136\132\1441\1981\198\156\243\132\144\247\222\255\255\255\255\255\255\247\222\132\144\189\2471\1981\198\255\255\222\251\255\255\255\255\255\255\255\255\255\255\222\251\255\2551\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\198")
scrollBar.downButton=image.new("\011\0\0\0\010\0\0\0\0\0\0\0\022\0\0\0\016\0\001\0001\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\198\255\255\222\251\255\255\255\255\255\255\255\255\255\255\222\251\255\2551\1981\198\156\243\132\144\247\222\255\255\255\255\255\255\247\222\132\144\189\2471\1981\198\132\144B\136B\136\247\222\255\255\247\222B\136B\136\132\1441\1981\198\247\222B\136!\132B\136R\202B\136!\132B\136\247\2221\1981\198\255\255\247\222B\136!\132\0\128!\132B\136\247\222\255\2551\1981\198\255\255\255\255\247\222B\136\0\128B\136\247\222\255\255\255\2551\1981\198\255\255\255\255\255\255\214\218\0\128\214\218\255\255\255\255\255\2551\1981\198\255\255\255\255\255\255\255\255\156\243\255\255\255\255\255\255\255\2551\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\1981\198")

function scrollBar:init(h, top, visible, total)
	self.color1	= {96, 100, 96}
	self.color2	= {184, 184, 184}
	
	self.hh	= h or 100
	self.ww = 14
	
	self.visible = visible or 10
	self.total   = total   or 15
	self.top     = top     or 4
end

function scrollBar:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x+1, self.y+1, self.w-1, self.h-1)
	
	gc:drawImage(self.upButton  , self.x+2, self.y+2)
	gc:drawImage(self.downButton, self.x+2, self.y+self.h-11)
	gc:setColorRGB(uCol(self.color1))
	if self.h > 28 then
		gc:drawRect(self.x + 3, self.y + 14, 8, self.h - 28)
	end
	
	if self.visible<self.total then
		local step	= (self.h-26)/self.total
		gc:fillRect(self.x + 3, self.y + 14  + step*self.top, 9, step*self.visible)
		gc:setColorRGB(uCol(self.color2))
		gc:fillRect(self.x + 2 , self.y + 14 + step*self.top, 1, step*self.visible)
		gc:fillRect(self.x + 12, self.y + 14 + step*self.top, 1, step*self.visible)
	end
end

function scrollBar:update(top, visible, total)
	self.top      = top     or self.top
	self.visible  = visible or self.visible
	self.total    = total   or self.total
end

function scrollBar:action(top) end

function scrollBar:mouseUp(x, y)
	local upX	= self.x+2
	local upY	= self.y+2
	local downX	= self.x+2
	local downY	= self.y+self.h-11
	local butH	= 10
	local butW	= 11
	
	--print(self.top.."  :  "..self.total.."  -  "..self.visible)
	
	if x>=upX and x<upX+butW and y>=upY and y<upY+butH and self.top>0 then --up
		self.top	= self.top-1
		self:action(self.top)
	elseif x>=downX and x<downX+butW and y>=downY and y<downY+butH and self.top<self.total-self.visible then --down
		self.top	= self.top+1
		self:action(self.top)
	end
end

function scrollBar:getFocus(n)
	if n==-1 or n==1 then
		self.parent:switchFocus(n)
	end
end


------------------------------------------------------------------
--                         List Widget                          --
------------------------------------------------------------------

sList	= class(WWidget)

function sList:init()
	Widget.init(self)
	self.dw	= 150
	self.dh	= 153

	self.ih	= 18

	self.top	= 0
	self.sel	= 1
	
	self.font	= {"sansserif", "r", 10}
	self.colors	= {50,150,190}
	self.items	= {}
end

function sList:appended()
	self.scrollBar	= scrollBar("100", self.top, #self.items,#self.items)
	self:appendWidget(self.scrollBar, -1, 0)
	
	function self.scrollBar:action(top)
		self.parent.top	= top
	end
end


function sList:paint(gc)
	local x	= self.x
	local y	= self.y
	local w	= self.w
	local h	= self.h
	
	
	local ih	= self.ih   
	local top	= self.top		
	local sel	= self.sel		
		      
	local items	= self.items			
	local visible_items	= math.floor(h/ih)	
	gc:setColorRGB(255, 255, 255)
	gc:fillRect(x, y, w, h)
	gc:setColorRGB(0, 0, 0)
	gc:drawRect(x, y, w, h)
	gc_clipRect(gc, "set", x, y, w, h)
	gc:setFont(unpack(self.font))

	
	
	local label, item
	for i=1, math.min(#items-top, visible_items+1) do
		item	= items[i+top]
		label	= textLim(gc, item, w-(5 + 12 + 2 + 1))
		
		if i+top == sel then
			gc:setColorRGB(unpack(self.colors))
			gc:fillRect(x+1, y + i*ih-ih + 1, w-(12 + 2 + 2), ih)
			
			gc:setColorRGB(255, 255, 255)
		end
		
		gc:drawString(label, x+5, y + i*ih-ih , "top")
		gc:setColorRGB(0, 0, 0)
	end
	
	self.scrollBar:update(top, visible_items, #items)
	
	gc_clipRect(gc, "reset")
end

function sList:arrowKey(arrow)	
    
	if arrow=="up" then
	    if self.sel>1 then
            self.sel	= self.sel - 1
            if self.top>=self.sel then
                self.top	= self.top - 1
            end
        else
            self.top = self.h/self.ih < #self.items and math.ceil(#self.items - self.h/self.ih) or 0
            self.sel = #self.items
        end
        self:change(self.sel, self.items[self.sel])
	end

	if arrow=="down" then
	    if self.sel<#self.items then
            self.sel	= self.sel + 1
            if self.sel>(self.h/self.ih)+self.top then
                self.top	= self.top + 1
            end
        else
            self.top = 0
            self.sel = 1
        end
        self:change(self.sel, self.items[self.sel])
	end
end


function sList:mouseUp(x, y)
	if x>=self.x and x<self.x+self.w-16 and y>=self.y and y<self.y+self.h then
		
		local sel	= math.floor((y-self.y)/self.ih) + 1 + self.top
		if sel==self.sel then
			self:enterKey()
			return
		end
		if self.items[sel] then
			self.sel=sel
			self:change(self.sel, self.items[self.sel])
		else
			return
		end
		
		if self.sel>(self.h/self.ih)+self.top then
			self.top	= self.top + 1
		end
		if self.top>=self.sel then
			self.top	= self.top - 1
		end
						
	end 
	self.scrollBar:mouseUp(x, y)
end


function sList:enterKey()
	if self.items[self.sel] then
		self:action(self.sel, self.items[self.sel])
	end
end


function sList:change() end
function sList:action() end

function sList:reset()
	self.sel	= 1
	self.top	= 0
end

------------------------------------------------------------------
--                        Screen Widget                         --
------------------------------------------------------------------

sScreen	= class(WWidget)

function sScreen:init(w, h)
	Widget.init(self)
	self.ww	= w
	self.hh	= h
	self.oy	= 0
	self.ox	= 0
	self.noloop	= true
end

function sScreen:appended()
	self.oy	= 0
	self.ox	= 0
end

function sScreen:paint(gc)
	gc_clipRect(gc, "set", self.x, self.y, self.w, self.h)
	self.x	= self.x + self.ox
	self.y	= self.y + self.oy
end

function sScreen:postPaint(gc)
	gc_clipRect(gc, "reset")
end

function sScreen:setY(y)
	self.oy	= y or self.oy
end
						
function sScreen:setX(x)
	self.ox	= x or self.ox
end

function sScreen:showWidget()
	local w	= self:getWidget()
	if not w then print("bye") return end
	local y	= self.y - self.oy
	local wy = w.y - self.oy
	
	if w.y-2 < y then
		print("Moving up")
		self:setY(-(wy-y)+4)
	elseif w.y+w.h > y+self.h then
		print("moving down")
		self:setY(-(wy-(y+self.h)+w.h+2))
	end
	
	if self.focus == 1 then
		self:setY(0)
	end
end

function sScreen:getFocus(n)
	if n==-1 or n==1 then
		self:stealFocus()
		self:switchFocus(n, true)
	end
end

function sScreen:loop(n)
	self.parent:switchFocus(n)
	self:showWidget()
end

function sScreen:focusChange()
	self:showWidget()
end

function sScreen:loseFocus(n)
	if n and ((n >= 1 and self.focus+n<=#self.widgets) or (n <= -1 and self.focus+n>=1)) then
		self:switchFocus(n)
		return -1
	else
		self:stealFocus()
	end
	
end


-------------------------------------------------------------------------------
--									sDropdown							     --
-------------------------------------------------------------------------------

sDropdown	=	class(Widget)


function sDropdown:init(items, width)
	self.dh	= 21 --height of the widget
	self.dw	= width --width of the widget
	self.screen	= WScreen()
	self.sList	= sList()
	self.sList.items	= items or {}
	self.screen:appendWidget(self.sList,0,0)
	self.sList.action	= self.listAction
	self.sList.loseFocus	= self.screenEscape
	self.sList.change	= self.listChange
	self.screen.escapeKey	= self.screenEscape
	self.lak	= self.sList.arrowKey	
	self.sList.arrowKey	= self.listArrowKey
	self.value	= items[1] or ""
	self.valuen	= #items>0 and 1 or 0
	self.rvalue	= items[1] or ""
	self.rvaluen=self.valuen
	
    self.focuscolor = platform.isColorDisplay() and {40,148,184} or {0,0,0}
	
	self.sList.parentWidget = self
	self.screen.parentWidget = self
	--self.screen.focus=1
end

function sDropdown:screenpaint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.h, self.w)
	gc:setColorRGB(0,0,0)
	gc:drawRect(self.x, self.y, self.h, self.w)
end

function sDropdown:mouseDown()
	self:open()
end


sDropdown.img = image.new("\14\0\0\0\7\0\0\0\0\0\0\0\28\0\0\0\16\0\1\000{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239al{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239{\239alalal{\239{\239\255\255\255\255\255\255\255\255\255\255\255\255{\239{\239alalalalal{\239{\239\255\255\255\255\255\255\255\255{\239{\239alalalalalalal{\239{\239\255\255\255\255{\239{\239alalalalalalalalal{\239{\239{\239{\239alalalalalalalalalalal{\239{\239alalalalalal")

function sDropdown:arrowKey(arrow)	
	if arrow=="up" then
		self.parent:switchFocus(self.focusUp or -1)
	elseif arrow=="down" then
		self.parent:switchFocus(self.focusDown or 1)
	elseif arrow=="left" then 
		self.parent:switchFocus(self.focusLeft or -1)
	elseif arrow == "right" then
		self:open()
	end
end

function sDropdown:listArrowKey(arrow)
	if arrow == "left" then
		self:loseFocus()
	else
		self.parentWidget.lak(self, arrow)
	end
end

function sDropdown:listChange(a, b)
	self.parentWidget.value  = b
	self.parentWidget.valuen = a
end

function sDropdown:open()
	self.screen.yy	= self.y+self.h
	self.screen.xx	= self.x-1
	self.screen.ww	= self.w + 13
	local h = 2+(18*#self.sList.items)
	
	local py	= self.parent.oy and self.parent.y-self.parent.oy or self.parent.y
	local ph	= self.parent.h
	
	self.screen.hh	= self.y+self.h+h>ph+py-10 and ph-py-self.y-self.h-10 or h
	if self.y+self.h+h>ph+py-10  and self.screen.hh<40 then
		self.screen.hh = h < self.y and h or self.y-5
		self.screen.yy = self.y-self.screen.hh
	end
	
	self.sList.ww = self.w + 13
	self.sList.hh = self.screen.hh-2
	self.sList.yy =self.sList.yy+1
	self.sList:giveFocus()
	
    self.screen:size()
	push_screen_direct(self.screen)
end

function sDropdown:listAction(a,b)
	self.parentWidget.value  = b
	self.parentWidget.valuen = a
	self.parentWidget.rvalue  = b
	self.parentWidget.rvaluen = a
	self.parentWidget:change(a, b)
	remove_screen()
end

function sDropdown:change() end

function sDropdown:screenEscape()
	self.parentWidget.sList.sel = self.parentWidget.rvaluen
	self.parentWidget.value	= self.parentWidget.rvalue
	if current_screen() == self.parentWidget.screen then
		remove_screen()
	end
end

function sDropdown:paint(gc)
	gc:setColorRGB(255, 255, 255)
	gc:fillRect(self.x, self.y, self.w-1, self.h-1)
	
	gc:setColorRGB(0,0,0)
	gc:drawRect(self.x, self.y, self.w-1, self.h-1)
	
	if self.hasFocus then
        gc:setColorRGB(uCol(self.focuscolor))
        gc:drawRect(self.x-1, self.y-1, self.w+1, self.h+1)
        gc:setColorRGB(0, 0, 0)
    end
	
	gc:setColorRGB(192, 192, 192)
	gc:fillRect(self.x+self.w-21, self.y+1, 20, 19)
	gc:setColorRGB(224, 224, 224)
	gc:fillRect(self.x+self.w-22, self.y+1, 1, 19)
	
	gc:drawImage(self.img, self.x+self.w-18, self.y+9)
	
	gc:setColorRGB(0,0,0)
	local text = self.value
	if self.unitmode then
		text=text:gsub("([^%d]+)(%d)", numberToSub)
	end
	
	gc:drawString(textLim(gc, text, self.w-5-22), self.x+5, self.y, "top")
end
function math.solve(formula, tosolve)
    --local eq="max(exp" .. string.uchar(9654) .. "list(solve(" .. formula .. ", " .. tosolve ..")," .. tosolve .."))"
    local eq = "nsolve(" .. formula .. ", " .. tosolve .. ")"
    local res = tostring(math.eval(eq)):gsub(utf8(8722), "-")
    --print("-", eq, math.eval(eq), tostring(math.eval(eq)), tostring(math.eval(eq)):gsub(utf8(8722), "-"))
    return tonumber(res)
end

function round(num, idp)
    if num >= 0.001 or num <= -0.001 then
        local mult = 10 ^ (idp or 0)
        if num >= 0 then
            return math.floor(num * mult + 0.5) / mult
        else
            return math.ceil(num * mult - 0.5) / mult
        end
    else
        return tonumber(string.format("%.0" .. (idp + 1) .. "g", num))
    end
end

math.round = round -- just in case

function find_data(known, cid, sid)
    local done = {}

    for _, var in ipairs(var.list()) do
        math.eval("delvar " .. var)
    end

    for key, value in pairs(known) do
        var.store(key, value)
    end

    local no
    local dirty_exit = true
    local tosolve
    local couldnotsolve = {}

    local loops = 0
    while dirty_exit do
        loops = loops + 1
        if loops == 100 then error("too many loops!") end
        dirty_exit = false

        for i, formula in ipairs(Formulas) do

            local skip = false
            if couldnotsolve[formula] then
                skip = true
                for k, v in pairs(known) do
                    if not couldnotsolve[formula][k] then
                        skip = false
                        couldnotsolve[formula] = nil
                        break
                    end
                end
            end

            if ((not cid) or (cid and formula.category == cid)) and ((not sid) or (formula.category == cid and formula.sub == sid)) and not skip then
                no = 0

                for var in pairs(formula.variables) do
                    if not known[var] then
                        no = no + 1
                        tosolve = var
                        if no == 2 then break end
                    end
                end

                if no == 1 then
                    print("I can solve " .. tosolve .. " for " .. formula.formula)

                   
                    local sol, r = math.solve(formula.formula, tosolve)
                    if sol then
                        sol = round(sol, 4)
                        known[tosolve] = sol
                        done[formula] = true
                        var.store(tosolve, sol)
                        couldnotsolve[formula] = nil
                        print(tosolve .. " = " .. sol)
                    else
                        print("Oops! Something went wrong:", r)
                        -- Need to issue a warning dialog
                        couldnotsolve[formula] = copyTable(known)
                    end
                    dirty_exit = true
                    break

                elseif no == 2 then
                    print("I cannot solve " .. formula.formula .. " because I don't know the value of multiple variables")
                end
            end
        end
    end

    return known
end

function find_dataQuad(known, form)
    result = {}
    for a, b in pairs(known) do
        print(a, b)
    end
    --if form == "Allgemeine Form" then
        result[0]=-known["b"]/known["a"]/2+math.sqrt(((known["b"]/known["a"])^2)/4-known["c"]/known["a"])*-1
        result[1]=-known["b"]/known["a"]/2-math.sqrt(((known["b"]/known["a"])^2)/4-known["c"]/known["a"])*-1
    --end
    return result
end


CategorySel = WScreen()
CategorySel.iconS = 48

CategorySel.sublist = sList()
CategorySel:appendWidget(CategorySel.sublist, 5, 5 + 24)
CategorySel.sublist:setSize(-10, -70)
CategorySel.sublist.cid = 0

function CategorySel.sublist:action(sid)
    push_screen(SubCatSel, sid)
end

function CategorySel:charIn(ch)
    if ch == "l" then
        loadExtDB()
        self:pushed() -- refresh list
        self:invalidate() -- asks for screen repaint
    end
end

function CategorySel:paint(gc)
    gc:setColorRGB(255, 255, 255)
    gc:fillRect(self.x, self.y, self.w, self.h)

    if not kIsInSubCatScreen then
        gc:setColorRGB(0, 0, 0)
        gc:setFont("sansserif", "r", 16)
        gc:drawString("GoRoot", self.x + 5, 0, "top")

        gc:setFont("sansserif", "r", 12)
        gc:drawString("v1.0b", self.x + .4 * self.w, 4, "top")

        gc:setFont("sansserif", "r", 12)
        gc:drawString("by Lukas", self.x + self.w - gc:getStringWidth("by Lukas") - 5, 4, "top")

        gc:setColorRGB(220, 220, 220)
        gc:setFont("sansserif", "r", 8)
        gc:drawRect(5, self.h - 46 + 10, self.w - 10, 25 + 6)
        gc:setColorRGB(128, 128, 128)
    end

    local splinfo = Categories[self.sublist.sel].info:split("\n")
    for i, str in ipairs(splinfo) do
        gc:drawString(str, self.x + 7, self.h - 56 + 12 + i * 10, "top")
    end
    self.sublist:giveFocus()
end

function CategorySel:pushed()
    local items = {}
    for cid, cat in ipairs(Categories) do
        table.insert(items, cat.name)
    end

    self.sublist.items = items
    self.sublist:giveFocus()
end

function CategorySel:tabKey()
    push_screen_back(Ref)
end



SubCatSel = WScreen()
SubCatSel.sel = 1

SubCatSel.sublist = sList()
SubCatSel:appendWidget(SubCatSel.sublist, 5, 5 + 24)
SubCatSel.back = sButton(utf8(9664) .. " Zur¸ck")
SubCatSel:appendWidget(SubCatSel.back, 5, -5)
SubCatSel.sublist:setSize(-10, -66)
SubCatSel.sublist.cid = 0

function SubCatSel.back:action()
    SubCatSel:escapeKey()
end

function SubCatSel.sublist:action(sub)
    local cid = self.parent.cid
    -- !!!
    -- Disabled Secure Start
    -- !!!
    --if #Categories[cid].sub[sub].formulas > 0 then
        push_screen(manualSolver, cid, sub)
    --end
end

function SubCatSel:paint(gc)
    gc:setColorRGB(255, 255, 255)
    gc:fillRect(self.x, self.y, self.w, self.h)
    gc:setColorRGB(0, 0, 0)
    gc:setFont("sansserif", "r", 16)
    gc:drawString(Categories[self.cid].name, self.x + 5, 0, "top")
end

function SubCatSel:pushed(sel)

    kIsInSubCatScreen = true
    self.cid = sel
    local items = {}
    for sid, subcat in ipairs(Categories[sel].sub) do
        table.insert(items, subcat.name .. ("")) --#subcat.formulas == 0 and " (Empty)" or 
    end

    if self.sublist.cid ~= sel then
        self.sublist.cid = sel
        self.sublist:reset()
    end

    self.sublist.items = items
    self.sublist:giveFocus()
end

function SubCatSel:escapeKey()
    kIsInSubCatScreen = false
    only_screen_back(CategorySel)
end



-------------------
-- Manual solver --
-------------------

manualSolver = WScreen()
manualSolver.pl = sScreen(-20, -50)
manualSolver:appendWidget(manualSolver.pl, 2, 4)

--manualSolver.sb = scrollBar(-50)
manualSolver.sb = scrollBar(-50)
manualSolver:appendWidget(manualSolver.sb, -2, 3)

manualSolver.back = sButton(utf8(9664) .. " Zur¸ck")
manualSolver:appendWidget(manualSolver.back, 5, -6)

manualSolver.usedFormulas = sButton("Formeln")
manualSolver:appendWidget(manualSolver.usedFormulas, -5, -6)

function manualSolver.back:action()
    manualSolver:escapeKey()
end

function manualSolver.usedFormulas:action()
    push_screen_direct(usedFormulas)
end

function manualSolver.sb:action(top)
    self.parent.pl:setY(4 - top * 30)
end

function manualSolver:paint(gc)
    gc:setColorRGB(224, 224, 224)
    gc:fillRect(self.x, self.y, self.w, self.h)
    gc:setColorRGB(128, 128, 128)
    gc:fillRect(self.x + 5, self.y + self.h - 42, self.w - 10, 2)
    self.sb:update(math.floor(-(self.pl.oy - 4) / 30 + .5))

    gc:setFont("sansserif", "r", 10)
    local name = self.sub.name
    local len = gc:getStringWidth(name)
    if len >= .7*self.w then name = string.sub(name, 1, -10) .. ". " end
    local len = gc:getStringWidth(name)
    local x = self.x + (self.w - len) / 2 - 4

    --gc:setColorRGB(255,255,255)
    --gc:fillRect(x-3, 10, len+6, 18)

    gc:setColorRGB(0, 0, 0)
    gc:drawString(name, x, self.h - 30, "top")
    --gc:drawRect(x-3, 10, len+6, 18)
end

function manualSolver:postPaint(gc)
    --gc:setColorRGB(128,128,128)
    --gc:drawRect(self.x, self.y, self.w, self.h-46)
end

basicFuncsInited = false

function manualSolver:pushed(cid, sid)

    if not basicFuncsInited then
        initBasicFunctions()
        basicFuncsInited = true
    end

    self.pl.widgets = {}
    self.pl.focus = 0
    self.cid = cid
    self.sid = sid
    self.sub = Categories[cid].sub[sid]
    self.pl.oy = 0
    self.known = {}
    self.inputs = {}
    self.constants = {}

    local inp, lbl
    local i = 0
    local nodropdown, lastdropdown
    -- important change
    if cid == 2 and sid == 1 then
    
        inp = sInput(100)
        form_labels = {}
        table.insert(form_labels, "Allgemeine Form")
        table.insert(form_labels, "Scheitelpunktform")
        table.insert(form_labels, "Faktorisierte Form")
        inp.dropdown = sDropdown(form_labels, 150)
        inp.dropdown.unitmode = false
        inp.dropdown.change = self.update
        inp.w = 1500
        nodropdown = false
        inp.dropdown.focusUp = nodropdown and -5 or -4
        inp.dropdown.focusDown = 2
        self.pl:appendWidget(inp.dropdown, 30, 7) --coordinates
        inp.getFocus = manualSolver.update
        self.inputs["form"] = inp
        
        vars = {}
        table.insert(vars, "a")
        table.insert(vars, "b")
        table.insert(vars, "c")
        
        i = 0
        for _, variable in pairs(vars) do
            i = i + 1
            inp = sInput(10)
            inp.value = ""
            --self.inputs[variable] = inp
            inp.ww = 50
            inp.focusDown = 4
            inp.focusUp = -2
            self.inputs[variable] = inp
            lbl = sLabel(variable, inp)
            self.pl:appendWidget(inp, i * 90 - 60, 1 * 30 + 5)
            self.pl:appendWidget(lbl, i * 90 - 80, 1 * 30 + 5)
            self.pl:appendWidget(sLabel(":", inp), i * 90 - 70, 1 * 30 + 5)
            inp.getFocus = manualSolver.update
            function inp:enterKey()
                if not tonumber(self.value) and #self.value > 0 then
                    if not manualSolver:preSolve(self) then
                        self.value = self.value .. "   " .. utf8(8658) .. " Invalid input"
                    end
                end
                manualSolver:solveQuad()
                self.parent:switchFocus(1)
            end
        end
        
        forms = {}
        table.insert(forms, "ax^2+bx+c")
        table.insert(forms, "a(x-b)^2+c")
        table.insert(forms, "a(x-b)(x-c)")
        
        i = 0
        form_labels2 = {}
        for i, f_label in pairs(form_labels) do
            form_labels2[i] = f_label
        end
        
        i = 0
        for i, form in pairs(forms) do
            inp = sInput(10)
            inp.placeholder = forms[i]
            inp.ww = 150
            inp.focusDown = 2
            inp.focusUp = -2
            self.inputs[form_labels2[i]] = inp
            lbl = sLabel(form_labels2[i], inp)
            self.pl:appendWidget(inp, 30, i * 60 + 28)
            self.pl:appendWidget(lbl, 2, i * 60 + 0)
            self.pl:appendWidget(sLabel(":", inp), 110, i * 60 + 0)
            inp.getFocus = manualSolver.update
        end
        
        --manualSolver.sb:update(0, 9, 8)
        self.pl:giveFocus()
        self.pl.focus = 1
        self.pl:getWidget().hasFocus = true
        self.pl:getWidget():getFocus() 
    else
        for variable, _ in pairs(self.sub.variables) do
    
    
            if not Constants[variable] or Categories[cid].varlink[variable] then
                i = i + 1
                inp = sInput(100)
                inp.value = ""
                --inp.number	= true
    
                function inp:enterKey()
                    if not tonumber(self.value) and #self.value > 0 then
                        if not manualSolver:preSolve(self) then
                            self.value = self.value .. "   " .. utf8(8658) .. " Invalid input"
                        end
                    end
                    manualSolver:solve()
                    self.parent:switchFocus(1)
                end
    
                self.inputs[variable] = inp
                inp.ww = -145
                inp.focusDown = 4
                inp.focusUp = -2
                lbl = sLabel(variable, inp)
    
                self.pl:appendWidget(inp, 60, i * 30 - 28)
                self.pl:appendWidget(lbl, 2, i * 30 - 28)
                self.pl:appendWidget(sLabel(":", inp), 50, i * 30 - 28)
    
                print(variable)
                local variabledata = Categories[cid].varlink[variable]
                inp.placeholder = variabledata.info
    
                if nodropdown then
                    inp.focusUp = -1
                end
    
                if variabledata then
                    if variabledata.unit ~= "unitless" then
                        --unitlbl	= sLabel(variabledata.unit:gsub("([^%d]+)(%d)", numberToSub))
                        local itms = { variabledata.unit }
                        for k, _ in pairs(Units[variabledata.unit]) do
                            table.insert(itms, k)
                        end
                        inp.dropdown = sDropdown(itms, 75)
                        inp.dropdown.unitmode = true
                        inp.dropdown.change = self.update
                        inp.dropdown.focusUp = nodropdown and -5 or -4
                        inp.dropdown.focusDown = 2
                        --change this line (-2)
                        --self.pl:appendWidget(inp.dropdown, 20, i * 30 - 28)
                        self.pl:appendWidget(inp.dropdown, -2, i * 30 - 28)
                        nodropdown = false
                        lastdropdown = inp.dropdown
                    else
                        self.pl:appendWidget(sLabel("Unitless"), -32, i * 30 - 28)
                                                                                                                                                                                                                                             end
                else
                    nodropdown = true
                    inp.focusDown = 1
                    if lastdropdown then
                        lastdropdown.focusDown = 1
                        lastdropdown = false
                    end
                end
    
                inp.getFocus = manualSolver.update
            else
                self.constants[variable] = math.eval(Constants[variable].value)
                --var.store(variable, self.known[variable])
            end
        end
    end
    inp.focusDown = 1

    manualSolver.sb:update(0, math.floor(self.pl.h / 30 + .5), i)
    self.pl:giveFocus()

    self.pl.focus = 1
    self.pl:getWidget().hasFocus = true
    self.pl:getWidget():getFocus()
end

function manualSolver.update()
    manualSolver:solve()
end

function manualSolver:preSolve(input) --solves terms in an input field (such aus 3*3) and checks if the input is a number
    local res, err
    res, err = math.eval(input.value)
    res = res and round(res, 4)
    print("Presolve : ", input.value .. " = " .. tostring(res), "(err ? = " .. tostring(err) .. ")")
    input.value = res and tostring(res) or input.value
    return res and 1 or false
end

function manualSolver:solveQuad()
    local inputed = {} --contains all the inputed variabled
    
    for variable, input in pairs(self.inputs) do
        local variabledata = Categories[self.cid].varlink[variable] --get the variable unit?
        if input.disabled then --deletes disabled (grey) fields
            inputed[variable] = nil
            input.value = ""
        end
    
        input:enable()
        if input.value ~= "" then
            local tmpstr = input.value:gsub(utf8(8722), "-")
            inputed[variable] = tonumber(tmpstr)
        end
    end
    
    form = self.inputs["form"].dropdown.rvalue
    result = find_dataQuad(inputed, form)
    print(result[0], result[1])
    self.inputs["Faktorisierte Form"].value = inputed["a"].."(x"..result[0]..")(x"..result[1]
    self.inputs["Faktorisierte Form"]:disable()
end

function manualSolver:solve()
    local inputed = {} --contains all the inputed variabled
    local disabled = {} --useless

    for variable, input in pairs(self.inputs) do
        local variabledata = Categories[self.cid].varlink[variable] --get the variable unit?
        if input.disabled then --deletes disabled (grey) fields
            inputed[variable] = nil
            input.value = ""
        end

        input:enable()
        if input.value ~= "" then
            local tmpstr = input.value:gsub(utf8(8722), "-")
            inputed[variable] = tonumber(tmpstr)
            if input.dropdown and input.dropdown.rvalue ~= variabledata.unit then --if the selected unit isn't the main unit
                inputed[variable] = Units.subToMain(variabledata.unit, input.dropdown.rvalue, inputed[variable]) --from the subunit (kilometer) to the main unit (meter)
            end
        end
    end

    local invs = copyTable(inputed)
    for k, v in pairs(self.constants) do
        invs[k] = v --set constants
    end
    self.known = find_data(invs, self.cid, self.sid) --solve unknown variables

    for variable, value in pairs(self.known) do
        if (not inputed[variable] and self.inputs[variable]) then
            local variabledata = Categories[self.cid].varlink[variable]
            local result = tostring(value)
            local input = self.inputs[variable]

            if input.dropdown and input.dropdown.rvalue ~= variabledata.unit then --if the selected unit isn't the main unit
                result = Units.mainToSub(variabledata.unit, input.dropdown.rvalue, result) --from the main unit (meter) to the subunit (kilometer)
            end

            input.value = result --set the solved variable
            input:disable() --make it grey and not writeable
        end
    end
end

function manualSolver:escapeKey()
    only_screen_back(SubCatSel, self.cid)
end

function manualSolver:contextMenu()
    push_screen_direct(usedFormulas)
end

usedFormulas = Dialog("Formeln", 10, 10, -20, -20)

usedFormulas.but = sButton("Schlieﬂen")

usedFormulas:appendWidget(usedFormulas.but, -10, -5)

function usedFormulas:postPaint(gc)
    if self.ed then
        self.ed:move(self.x + 5, self.y + 30)
        self.ed:resize(self.w - 9, self.h - 74)
    end

    nativeBar(gc, self, self.h - 40)
end

function usedFormulas:pushed()
    doNotDisplayIcon = true
    self.ed = D2Editor.newRichText()
    self.ed:setReadOnly(true)
    local cont = ""

    local fmls = #manualSolver.sub.formulas
    for k, v in ipairs(manualSolver.sub.formulas) do
        cont = cont .. k .. ": \\0el {" .. v.formula .. "} " .. (k < fmls and "\n" or "")
    end

    if self.ed.setExpression then
        self.ed:setExpression(cont, 1)
        self.ed:registerFilter{ escapeKey = usedFormulas.closeEditor, enterKey = usedFormulas.closeEditor, tabKey = usedFormulas.leaveEditor }
        self.ed:setFocus(true)
    else
        self.ed:setText(cont, 1)
    end

    self.but:giveFocus()
end

function usedFormulas.leaveEditor()
    platform.window:setFocus(true)
    usedFormulas.but:giveFocus()
    return true
end

function usedFormulas.closeEditor()
    platform.window:setFocus(true)
    if current_screen() == usedFormulas then
        remove_screen()
    end
    doNotDisplayIcon = false
    return true
end

function usedFormulas:screenLoseFocus()
    self:removed()
end

function usedFormulas:screenGetFocus()
    self:pushed()
end

function usedFormulas:removed()
    if usedFormulas.ed.setVisible then
        usedFormulas.ed:setVisible(false)
    else
        usedFormulas.ed:setText("")
        usedFormulas.ed:resize(1, 1)
        usedFormulas.ed:move(-10, -10)
    end
    usedFormulas.ed = nil
    doNotDisplayIcon = false
end

function usedFormulas.but.action(self)
    remove_screen()
end	


function initBasicFunctions()
    local basicFunctions = {
        ["erf"] = [[Define erf(x)=Func:2/sqrt(pi)*integral(exp(-t*t),t,0,x):EndFunc]],
        ["erfc"] = [[Define erfc(x)=Func:1-erf(x):EndFunc]],
        ["ni"] = [[Define ni(ttt)=Func:7.7835*10^21*ttt^(3/2)*exp((4.73*10^-4*ttt^2/(ttt+636)-1.17)/(1.72143086667*10^-4*ttt)):EndFunc]],
        ["eegalv"] = [[Define eegalv(rrx,rr2,rr3,rr4,rrg,rrs,vs)=Func:Local rra,rrb,rrc,vb,rg34,rx2ab: rg34:=rrg+rr3+rr4:  rra:=((rrg*rr3)/(rg34)): rrb:=((rrg*rr4)/(rg34)): rrc:=((rr3*rr4)/(rg34)): rx2ab:=rrx+rr2+rra+rrb: rra:=((rrg*rr3)/(rg34)): vb:=((((vs*(rrx+rra)*(rr2+rrb))/(rx2ab)))/(rrs+rrc+(((rrx+rra)*(rr2+rrb))/(rx2ab)))): vb*(((rx)/(rrx+rra))-((rr2)/(rr2+rrb))):Return :EndFunc]],
    }
    for var, func in pairs(basicFunctions) do
        math.eval(func .. ":Lock " .. var) -- defines and prevents against delvar.
    end
end

RefBoolAlg = Screen()

RefBoolAlg.data = {
    { "x+0=x", "x.1=x", "Identity" },
    { "x+x'=1", "x.x'=0", "Inverse" },
    { "x+x=x", "x.x=x", "Idempotent" },
    { "x+1=1", "x.0=0", "Null Element" },
    { "(x')'=x", "(x')'=x", "Involution" },
    { "x+y=y+x", "x.y=y.x", "Commutative" },
    { "x+(y+z)=(x+y)+z", "x.(y.z)=(x.y).z", "Associative" },
    { "x.(y+z)=(x.y)+(x.z)", "x+(y.z)=(x+y).(x+z)", "Distributive" },
    { "x+(x.y)=x", "x.(x+y)=x", "Absorption" },
    { "(x+y+z)'=x'.y'.z'", "(x.y.z)'=x'+y'+z'", "DeMorgan's Law" },
    { "(x.y)+(x'.z)+(y.z)=(x.y)+(x'.z)", "(x+y).(x'+z).(y+z)=(x+y).(x'+z)", "Consensus" }
}

RefBoolAlg.tmpScroll = 1
RefBoolAlg.dual = false

function RefBoolAlg:arrowKey(arrw)
    if pww() < 330 then
        if arrw == "up" then
            RefBoolAlg.tmpScroll = RefBoolAlg.tmpScroll - test(RefBoolAlg.tmpScroll > 1)
        end
        if arrw == "down" then
            RefBoolAlg.tmpScroll = RefBoolAlg.tmpScroll + test(RefBoolAlg.tmpScroll < (table.getn(RefBoolAlg.data) - 7))
        end
        screenRefresh()
    end
end

function RefBoolAlg:enterKey()
    RefBoolAlg.dual = not RefBoolAlg.dual
    RefBoolAlg:invalidate()
end

function RefBoolAlg:escapeKey()
    only_screen_back(Ref)
end

function RefBoolAlg:paint(gc)
    gc:setColorRGB(255, 255, 255)
    gc:fillRect(self.x, self.y, self.w, self.h)
    gc:setColorRGB(0, 0, 0)

    msg = "Boolean Algebra : "
    gc:setFont("sansserif", "b", 12)
    if RefBoolAlg.tmpScroll > 1 and pww() < 330 then
        gc:drawString(utf8(9650), gc:getStringWidth(utf8(9664)) + 7, 0, "top")
    end
    if RefBoolAlg.tmpScroll < table.getn(RefBoolAlg.data) - 7 and pww() < 330 then
        gc:drawString(utf8(9660), pww() - 4 * gc:getStringWidth(utf8(9654)) - 2, 0, "top")
    end
    drawXCenteredString(gc, msg, 0)
    gc:setFont("sansserif", "i", 12)
    drawXCenteredString(gc, "Press Enter for Dual ", 15)
    gc:setFont("sansserif", "r", 12)

    local tmp = 0
    for k = RefBoolAlg.tmpScroll, table.getn(RefBoolAlg.data) do
        tmp = tmp + 1
        gc:setFont("sansserif", "b", 12)
        gc:drawString(RefBoolAlg.data[k][3], 3, 10 + 22 * tmp, "top")
        gc:setFont("sansserif", "r", 12)
        gc:drawString(RefBoolAlg.data[k][1 + test(RefBoolAlg.dual)], 125 - 32 * test(k == 11) * test(pww() < 330) + 30 * test(pww() > 330) + 12, 10 + 22 * tmp, "top")
    end
end


RefBoolExpr = Screen()

RefBoolExpr.data = {
{"F0","0","Null"},
{"F1","x.y","AND"},
{"F2","x.y'","Inhibition"},
{"F3","x","Transfer"},
{"F4","x'.y","Inhibition"},
{"F5","y","Transfer"},
{"F6","(x.y')+(x'.y)","Exclusive OR (XOR)"},
{"F7","x+y","OR"},
{"F8","(x+y)'","NOT OR (NOR)"},
{"F9","(x.y)+(x'.y')","Equivalence (XNOR)"},
{"F10","y'","Complement NOT"},
{"F11","x+y'","Implication"},
{"F12","x'","Complement (NOT)"},
{"F13","x'+y","Implication"},
{"F14","(x.y)'","NOT AND (NAND)"},
{"F15","1","Identity"}
}

RefBoolExpr.tmpScroll = 1

function RefBoolExpr:arrowKey(arrw)
	if arrw == "up" then
		RefBoolExpr.tmpScroll = RefBoolExpr.tmpScroll - test(RefBoolExpr.tmpScroll>1)
	end
	if arrw == "down" then
		RefBoolExpr.tmpScroll = RefBoolExpr.tmpScroll + test(RefBoolExpr.tmpScroll<(table.getn(RefBoolExpr.data)-7))
	end
	screenRefresh()
end

function RefBoolExpr:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.w, self.h)
	gc:setColorRGB(0,0,0)
	
	    msg = "Boolean Expressions : "
        gc:setFont("sansserif","b",12)
        if RefBoolExpr.tmpScroll > 1 then
        	gc:drawString(utf8(9650),gc:getStringWidth(utf8(9664))+7,0,"top")
        end
        if RefBoolExpr.tmpScroll < table.getn(RefBoolExpr.data)-7 then
        	gc:drawString(utf8(9660),pww()-4*gc:getStringWidth(utf8(9654))-2,0,"top")
        end
        drawXCenteredString(gc,msg,4)
        gc:setFont("sansserif","r",12)
        
       	local tmp = 0
       	for k=RefBoolExpr.tmpScroll,table.getn(RefBoolExpr.data) do
       		tmp = tmp + 1
       		gc:setFont("sansserif","b",12)
            gc:drawString(RefBoolExpr.data[k][1], 5, 5+22*tmp, "top")
        	gc:setFont("sansserif","r",12)
            gc:drawString(RefBoolExpr.data[k][2], 40+30*test(pww()>330)+15, 5+22*tmp, "top")
		    gc:drawString(RefBoolExpr.data[k][3], 134+50*test(pww()>330)+15, 5+22*tmp, "top")
		end
end

function RefBoolExpr:escapeKey()
	only_screen_back(Ref)
end


RefConstants = Screen()

RefConstants.data = {
{"Acceleration due to gravity","g","9.81 m*s^-2"},
{"Atomic mass unit","mu or u","1.66 x 10^-27 kg"},
{"Avogadro's Number","N","6.022 x 10^23 mol^-1"},
{"Bohr radius","a0","0.529 x 10^-10 m"},
{"Boltzmann constant","k","1.38 x 10^-23 J K^-1"},
{"Electron charge to mass ratio","-e/me","-1.7588 x 10^11 C kg^-1"},
{"Electron classical radius","re","2.818 x 10^-15 m"},
{"Electron mass energy (J)","mec2","8.187 x 10^-14 J"},
{"Electron mass energy (MeV)","mec2","0.511 MeV"},
{"Electron rest mass","me","9.109 x 10^-31 kg"},
{"Faraday constant","F","9.649 x 10^4 C mol^-1"},
{"Fine-structure constant",utf8(945),"7.297 x 10^-3"},
{"Gas constant","R","8.314 J mol-1 K^-1"},
{"Gravitational constant","G","6.67 x 10^-11 Nm^2 kg^-2"},
{"Neutron mass energy (J)","mnc2","1.505 x 10^-10 J"},
{"Neutron mass energy (MeV)","mnc2","939.565 MeV"},
{"Neutron rest mass","mn","1.675 x 10^-27 kg"},
{"Neutron-electron mass ratio","mn/me","1838.68"},
{"Neutron-proton mass ratio","mn/mp","1.0014"},
{"Permeability of a vacuum",utf8(956).."0","4*pi x 10^-7 N A^-2"},
{"Permittivity of a vacuum",utf8(949).."0","8.854 x 10^-12 F m^-1"},
{"Planck constant","h","6.626 x 10^-34 J s"},
{"Proton mass energy (J)","mpc2","1.503 x 10^-10 J"},
{"Proton mass energy (MeV)","mpc2","938.272 MeV"},
{"Proton rest mass","mp","1.6726 x 10^-27 kg"},
{"Proton-electron mass ratio","mp/me","1836.15"},
{"Rydberg constant","r","1.0974 x 10^7 m^-1"},
{"Speed of light in vacuum","C","2.9979 x 10^8 m/s"}
}

RefConstants.tmpScroll = 1
RefConstants.leftRight = 1

function RefConstants:arrowKey(arrw)
	if arrw == "up" then
		RefConstants.tmpScroll = RefConstants.tmpScroll - test(RefConstants.tmpScroll>1)
	end
	if arrw == "down" then
		RefConstants.tmpScroll = RefConstants.tmpScroll + test(RefConstants.tmpScroll<(table.getn(RefConstants.data)-7))
	end
	if arrw == "left" then
		RefConstants.leftRight = RefConstants.leftRight - 5*test(RefConstants.leftRight>1)
	end
	if arrw == "right" then
		RefConstants.leftRight = RefConstants.leftRight + 5*test(RefConstants.leftRight<150)
	end
	screenRefresh()
end

function RefConstants:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.w, self.h)
	gc:setColorRGB(0,0,0)
	
	    msg = "Physical Constants : "
        gc:setFont("sansserif","b",12)
        if RefConstants.leftRight > 1 then
        	gc:drawString(utf8(9664),4,0,"top")
        end
        if RefConstants.leftRight < 160 then
        	gc:drawString(utf8(9654),pww()-gc:getStringWidth(utf8(9660))-2,0,"top")
        end
        if RefConstants.tmpScroll > 1 then
        	gc:drawString(utf8(9650),gc:getStringWidth(utf8(9664))+7,0,"top")
        end
        if RefConstants.tmpScroll < table.getn(RefConstants.data)-7 then
        	gc:drawString(utf8(9660),pww()-4*gc:getStringWidth(utf8(9654))-2,0,"top")
        end
        drawXCenteredString(gc,msg,4)
        gc:setFont("sansserif","r",12)
        
       	local tmp = 0
       	for k=RefConstants.tmpScroll,table.getn(RefConstants.data) do
			tmp = tmp + 1
       		gc:setFont("sansserif","b",12)
            gc:drawString(RefConstants.data[k][1], 5-RefConstants.leftRight, 5+22*tmp, "top")
        	gc:setFont("sansserif","r",12)
            gc:drawString("  (" .. RefConstants.data[k][2] .. ") : " .. RefConstants.data[k][3] .. ". ", gc:getStringWidth(RefConstants.data[k][1])+15-RefConstants.leftRight, 5+22*tmp, "top")
		end
end

function RefConstants:escapeKey()
	only_screen_back(Ref)
end


Greek = Screen()
 
Greek.font = "serif"
  
Greek.alphabet1 = {
 { utf8(913), utf8(945), "Alpha" },
 { utf8(914), utf8(946), "Beta" },
 { utf8(915), utf8(947), "Gamma" },
 { utf8(916), utf8(948), "Delta" },
 { utf8(917), utf8(949), "Epsilon" },
 { utf8(918), utf8(950), "Zeta" },
 { utf8(919), utf8(951), "Eta" },
 { utf8(920), utf8(952), "Theta" }
}
Greek.alphabet2 = {
 { utf8(921), utf8(953), "Iota" },
 { utf8(922), utf8(954), "Kappa" },
 { utf8(923), utf8(955), "Lambda" },
 { utf8(924), utf8(956), "Mu" },
 { utf8(925), utf8(957), "Nu" },
 { utf8(926), utf8(958), "Xi" },
 { utf8(927), utf8(959), "Omicron" },
 { utf8(928), utf8(960), "Pi" }
}
Greek.alphabet3 = {
 { utf8(929), utf8(961), "Rho" },
 { utf8(931), utf8(963), "Sigma" },
 { utf8(932), utf8(964), "Tau" },
 { utf8(933), utf8(965), "Upsilon" },
 { utf8(934), utf8(966), "Phi" },
 { utf8(935), utf8(967), "Chi" },
 { utf8(936), utf8(968), "Psi" },
 { utf8(937), utf8(969), "Omega" }
}
 
function Greek:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.w, self.h)
	gc:setColorRGB(0,0,0)
	
        local msg = "Greek Alphabet"
        gc:setFont("sansserif","b",12)
        drawXCenteredString(gc,msg,5)
        gc:setFont(Greek.font,"r",12)
        for k,v in ipairs(Greek.alphabet1) do
                gc:drawString(v[3] .. " : " .. v[1] .. " " .. v[2], 5, 10+22*k, "top")
        end
        for k,v in ipairs(Greek.alphabet2) do
                gc:drawString(v[3] .. " : " .. v[1] .. " " .. v[2], 5+.34*pww(), 10+22*k, "top")
        end
        for k,v in ipairs(Greek.alphabet3) do
                gc:drawString(v[3] .. " : " .. v[1] .. " " .. v[2], 5+.67*pww(), 10+22*k, "top")
        end
end
 
function Greek:enterKey()
    Greek.font = Greek.font == "serif" and "sansserif" or "serif"
    Greek:invalidate()
end

function Greek:escapeKey()
	only_screen_back(Ref)
end


ResColor = Screen()

ResColor.colors = {
["silver"] = {217,217,217},
["gold"] = {255,211,76},
["black"] = {0,0,0},
["brown"] = {153,115,0},
["red"] = {255,0,0},
["orange"] = {255,102,0},
["yellow"] = {255,255,0},
["green"] = {0,204,0},
["blue"] = {3,69,218},
["pink"] = {204,0,204},
["grey"] = {140,140,140},
["white"] = {255,255,255}
}

resistor = class()

function resistor:init(value,colors,selection)
	self.value = value
	self.colors = colors
	self.selection = selection
end

-- Resistor = resistor({238,1,3},{5,6,11,3,2},1)
Resistor = resistor({23,1,3},{5,6,3,2},1)

ResColor.tolerance = {
["0.1"] = 10,
["0.25"] = 9,
["0.5"] = 8,
["2"] = 5,
["1"] = 4,
["5"] = 2,
["10"] = 1
}
ResColor.tolerancenr = {0.1,0.25,0.5,1,2,5,10}

ResColor.colortable = {"silver","gold","black","brown","red","orange","yellow","green","blue","pink","grey","white"}

function ResColor:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.w, self.h)
	gc:setColorRGB(0,0,0)
	
	Resistor:paint(gc)
end

function Resistor:paint(gc)
	local w,h = pww(),pwh()
	
	--------------
	-- resistor --
	--------------
	gc:setColorRGB(170,170,170)
	gc:fillRect((w-(w/4+w/3))/2,(h/2-h/5)/2+((h/2-h/5)/2+h/40)/2,w/4+w/3,h/40)
	
	gc:setColorRGB(230,206,170)
	gc:fillRect((w-w/2)/2-1,(h/2-h/5)/2-1,w/2+2,h/5+2)
	
	------------
	-- colors --
	------------
	for i=1,#self.colors do
		gc:setColorRGB(unpack(ResColor.colors[ResColor.colortable[self.colors[i]]]))
		gc:fillRect((w-w/2)/2+w/2/(#self.colors)*(i-0.85),(h/2-h/5)/2,w/2/(#self.colors+2),h/5)
	end
	
	-----------
	-- value --
	-----------
	gc:setColorRGB(0,0,0)
	gc:setFont("sansserif","b","11")
	local printstring = "Resistance: "..self.value[1]*self.value[2].." Ohm "..string.uchar(177).." "..ResColor.tolerancenr[self.value[3]].."%"
	gc:drawString(printstring,(w-gc:getStringWidth(printstring))/2,h/2,"top")
	
	---------------
	-- selection --
	---------------
	gc:setColorRGB(230,206,170)
	gc:setPen("medium","smooth")
	gc:drawRect((w-w/2)/2+w/2/(#self.colors)*(self.selection-0.85)+1,(h/2-h/5)/2+1,w/2/(#self.colors+2)-3,h/5-3)
end

function ResColor:arrowKey(arrow)
	Resistor:arrowKey(arrow)
end

function ResColor:charIn(char)
	Resistor:charIn(char)
end

function Resistor:arrowKey(arrow)
	---------------------
	-- color selection --
	---------------------
	if arrow=='right' and self.selection<#self.colors then
		self.selection = self.selection + 1
	elseif arrow=='left' and self.selection>1 then
		self.selection = self.selection - 1
	-----------
	-- value --
	-----------
	elseif arrow=='up' and self.selection<=#self.colors-2 and self.colors[self.selection]<12 then
		self.value[1] = self.value[1]+10^(#self.colors-2-self.selection)
		self.colors[self.selection] = self.colors[self.selection] + 1
	elseif arrow=='down' and self.selection<=#self.colors-2  and self.colors[self.selection]>3 then
		self.value[1] = self.value[1]-10^(#self.colors-2-self.selection)
		self.colors[self.selection] = self.colors[self.selection] - 1
	----------------
	-- multiplier --
	----------------
	elseif arrow=='up' and self.selection==#self.colors-1 and self.value[2] < 10000000 then
		self.value[2] = self.value[2]*10
		self.colors[self.selection] = self.colors[self.selection] + 1
	elseif arrow=='down' and self.selection==#self.colors-1 and self.value[2] > 0.01 then
		self.value[2] = self.value[2]/10
		self.colors[self.selection] = self.colors[self.selection] - 1
	---------------
	-- tolerance --
	---------------
	elseif arrow=='up' and self.selection==#self.colors and self.value[3]<7 then
		self.value[3] = self.value[3] + 1
		self.colors[self.selection] = ResColor.tolerance[tostring(ResColor.tolerancenr[self.value[3]])]
	elseif arrow=='down' and self.selection==#self.colors  and self.value[3]>1 then
		self.value[3] = self.value[3] - 1
		self.colors[self.selection] = ResColor.tolerance[tostring(ResColor.tolerancenr[self.value[3]])]
	end
	platform.window:invalidate()
end

function Resistor:charIn(char)
	if char=='+' and #self.colors==4 then
		table.insert(self.colors,3,3)
		self.value[1] = self.value[1]*10
	elseif char=='-' and #self.colors==5 then
		local deletenr = (self.colors[3]-3)*self.value[2]
		self.value[1] = self.value[1]-deletenr
		table.remove(self.colors,3)
		self.value[1] = self.value[1]/10
	end
	platform.window:invalidate()
end

function ResColor:escapeKey()
	only_screen_back(Ref)
end

SIPrefixes = Screen()

SIPrefixes.prefixes1 = {
	{"Y", "Yotta", "24"},
	{"Z", "Zetta", "21"},
	{"E", "Exa", "18"},
	{"P", "Peta", "15"},
	{"T", "Tera", "12"},
	{"G", "Giga", "9"},
	{"M", "Mega", "6"},
	{"k", "Kilo", "3"},
	{"h", "Hecto", "2"},
	{"da", "Deka", "1"}
}

SIPrefixes.prefixes2 = {
	{"d", "Deci", "-1"},
	{"c", "Centi", "-2"},
	{"m", "Milli", "-3"},
	{utf8(956), "Micro", "-6"},
	{"n", "Nano", "-9"},
	{"p", "Pico", "-12"},
	{"f", "Femto", "-15"},
	{"a", "Atto", "-18"},
	{"z", "Zepto", "-21"},
	{"y", "Yocto", "-24"}
}

function SIPrefixes:paint(gc)
	gc:setColorRGB(255,255,255)
	gc:fillRect(self.x, self.y, self.w, self.h)
	gc:setColorRGB(0,0,0)
	
	    local msg = "SI Prefixes  "
        gc:setFont("sansserif","b",12)
        drawXCenteredString(gc,msg,0)
        gc:setFont("sansserif","r",12)
        for k,v in ipairs(SIPrefixes.prefixes1) do
                gc:drawString("10", 5+.03*self.w, 3+19*k, "top")
                gc:drawString(v[3], 23+.03*self.w, 19*k-3, "top")
                gc:drawString(" : " .. v[2], 45+.03*self.w, 3+19*k, "top")
                gc:drawString("  (" .. v[1] .. ")", 98+.03*self.w, 3+19*k, "top")
        end
        for k,v in ipairs(SIPrefixes.prefixes2) do
                gc:drawString("10", 5+.52*self.w, 3+19*k, "top")
                gc:drawString(v[3], 23+.52*self.w, 19*k-3, "top")
                gc:drawString("  : " .. v[2], 45+.52*self.w, 3+19*k, "top")
                gc:drawString("  (" .. v[1] .. ")", 100+.52*self.w, 3+19*k, "top")
        end
end

function SIPrefixes:escapeKey()
	only_screen_back(Ref)
end


References	= {
	{title="Resistor color chart"     , info="", screen=ResColor    },
	{title="Standard Component Values", info="", screen=nil         },
	{title="Semiconductor Data",        info="", screen=nil         },
	{title="Boolean Expressions",       info="", screen=RefBoolExpr },
	{title="Boolean Algebra",           info="", screen=RefBoolAlg  },
	{title="Transforms",                info="", screen=nil         },
	{title="Constants",                 info="", screen=RefConstants},
	{title="SI Prefixes",               info="", screen=SIPrefixes  },
	{title="Greek Alphabet",            info="", screen=Greek       },
}

Ref	= WScreen()

RefList	= sList()
RefList:setSize(-8, -32)

Ref:appendWidget(RefList, 4, Ref.y+28)

function Ref.addRefs()
	for n, ref in ipairs(References) do
		if ref.screen then
			table.insert(RefList.items, ref.title)
		else
			table.insert(RefList.items, ref.title .. " (not yet done)")  -- TODO !
		end
	end
end

function RefList:action(ref)
	if References[ref].screen then
		push_screen(References[ref].screen)
	end
end

function Ref:pushed()
	RefList:giveFocus()
end

function Ref:paint(gc)
    gc:setFont("serif", "b", 16)
    gc:drawString("Reference", self.x+6, -2, "top")
    gc:setFont("serif", "r", 12)
end

function Ref:tabKey()
    push_screen(CategorySel)
end

Ref.escapeKey = Ref.tabKey

Ref.addRefs()



aboutWindow	= Dialog("About FormulaPro :", 50, 20, 280, 180)

local aboutstr	= [[GoRoot v1.0b
--------------------
Lukas Fausten
-------------------
Main Classes and Functions are from
FormulaPro v1.42b
So here are there Credits:

Jim Bauwens, Adrien "Adriweb" Bertrand
Thanks also to Levak.
LGPL3 License.
More info and contact : 
tiplanet.org  -  inspired-lua.org


Tip : Press [Tab] for Reference !]]

local aboutButton	= sButton("OK")

for i, line in ipairs(aboutstr:split("\n")) do
	local aboutlabel	= sLabel(line)
	aboutWindow:appendWidget(aboutlabel, 10, 27 + i*14-12)
end

aboutWindow:appendWidget(aboutButton,-10,-5)

function aboutWindow:postPaint(gc)
	nativeBar(gc, self, self.h-40)
	on.help = function() return 0 end
end

aboutButton:giveFocus()

function aboutButton:action()
	remove_screen(aboutWindow)
	on.help = function() push_screen_direct(aboutWindow) end
end

----------------------------------------

function on.help()
	push_screen_direct(aboutWindow)
end

----------------------------------------


function errorPopup(gc)
    
    errorHandler.display = false

    errorDialog = Dialog("Oops...", 50, 20, "85", "80")

    local textMessage	= [[GoRoot has encountered an error
-----------------------------
Sorry for the inconvenience.
Please report this bug to me.
How/where/when it happened etc.
 (bug at line ]] .. errorHandler.errorLine .. ")"
    
    local errorOKButton	= sButton("OK")
    for i, line in ipairs(textMessage:split("\n")) do
        local errorLabel = sLabel(line)
        errorDialog:appendWidget(errorLabel, 10, 27 + i*14-12)
    end
    
    errorDialog:appendWidget(errorOKButton,-10,-5)
    
    function errorDialog:postPaint(gc)
        nativeBar(gc, self, self.h-40)
    end
    
    errorOKButton:giveFocus()
    
    function errorOKButton:action()
        remove_screen(errorDialog)
        errorHandler.errorMessage = nil
    end
    
    push_screen_direct(errorDialog)
end

---------------------------------------------------------------

function on.create()
	platform.os = "3.1"
end

function on.construction()
	platform.os = "3.2"
end

errorHandler = {}

function handleError(line, errMsg, callStack, locals)
    print("Error handled !", errMsg)
    errorHandler.display = true
    errorHandler.errorMessage = errMsg
    errorHandler.errorLine = line
    errorHandler.callStack = callStack
    errorHandler.locals = locals
    platform.window:invalidate()
    return true -- go on....
end

if platform.registerErrorHandler then
    platform.registerErrorHandler( handleError )
end



----------------------------------------------  Launch !

push_screen_direct(CategorySel)
