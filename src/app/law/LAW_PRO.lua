LAW = {}
LAW.mt = {}
function LAW.new (name,grid,cells,LAWs)
	local set = import("app.law."..name)
	set.grid = grid
	set.cells = cells
	set.LAWs = LAWs
	setmetatable(set, LAW.mt)
	-- for _,l in ipairs(t) do set[l] = true end
	return set
end

function LAW.tostring(set)
	local s = "{\n"
	local sep = ""
	for k,e in pairs(set) do
		s = s .. sep .. e
		sep = ", "
	end
	return s .. "\n}"
end

function  LAW.print(s)
	print(LAW.tostring(s))
end

LAW.mt.__lt = function(a,b)
	return a.level < b.level
end

LAW.mt.__le = function(a,b)
	return a.level <= b.level
end

LAW.mt.__eq = function(a,b)
	return a.level == b.level
end