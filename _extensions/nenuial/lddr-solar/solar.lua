local lustache = require 'assets/lua/lustache'
local solar_system = {
  Sun = { english = "Sun",     french = "Soleil",  type_en = "G2V star",        type_fr = "Étoile G2V",        distance = {},    mass = 1989e27,   radius = 695508, density = 1.41, rotation = "25.4 - 35 d", revolution = {} },
  Mercury = { english = "Mercury", french = "Mercure", type_en = "Telluric planet", type_fr = "Planète tellurique", distance = 0.387, mass = 3.302e+23, radius = 2440, density = 5.43, rotation = "56.646 d", revolution = 0.2408 },
  Venus = { english = "Venus", french = "Venus", type_en = "Telluric planet", type_fr = "Planète tellurique", distance = 0.723, mass = 4.869e+24, radius = 6052, density = 5.24, rotation = "243.018 d", revolution = 0.6152 },
  Earth = { english = "Earth", french = "Terre", type_en = "Telluric planet", type_fr = "Planète tellurique", distance = 1.0, mass = 5.974e+24, radius = 6378, density = 5.52, rotation = "23.934 h", revolution = 1.0 },
  Mars = { english = "Mars", french = "Mars", type_en = "Telluric planet", type_fr = "Planète tellurique", distance = 1.524, mass = 6.419e+23, radius = 3397, density = 3.94, rotation = "24.623 h", revolution = 1.8808 },
  Jupiter = { english = "Jupiter", french = "Jupiter", type_en = "Gaseous planet", type_fr = "Planète gazeuse", distance = 5.203, mass = 1.899e+27, radius = 71492, density = 1.33, rotation = "9.925 h", revolution = 11.862 },
  Saturn = { english = "Saturn", french = "Saturne", type_en = "Gaseous planet", type_fr = "Planète gazeuse", distance = 9.537, mass = 5.685e+26, radius = 60268, density = 0.7, rotation = "10.656 h", revolution = 29.457 },
  Uranus = { english = "Uranus", french = "Uranus", type_en = "Gaseous planet", type_fr = "Planète gazeuse", distance = 19.19, mass = 8.662e+25, radius = 25559, density = 1.3, rotation = "17.24 h", revolution = 84.018 },
  Neptune = { english = "Neptune", french = "Neptune", type_en = "Gaseous planet", type_fr = "Planète gazeuse", distance = 30.07, mass = 1.028e+26, radius = 24764, density = 1.76, rotation = "16.11 h", revolution = 164.78 },
  Pluto = { english = "Pluto", french = "Pluton", type_en = "Dwarf planet", type_fr = "Planète naine", distance = 39.48, mass = 1.314e+22, radius = 1151, density = 2.0, rotation = "6.387 d", revolution = 248.4 },
}

local templates = require("assets/templates/templates")

local english_strings = {
  distance        = "Distance to Sun",
  distance_unit   = "AU",
  mass            = "Mass",
  radius          = "Equatorial radius",
  density         = "Density",
  rotation        = "Rotation period",
  revolution      = "Revolution period",
  revolution_unit = "years"
}

local french_strings = {
  distance        = "Distance au Soleil",
  distance_unit   = "UA",
  mass            = "Masse",
  radius          = "Rayon équatorial",
  density         = "Densité",
  rotation        = "Période de rotation",
  revolution      = "Période de révolution",
  revolution_unit = "années"
}

local function readFile(filePath)
  local file = io.open(filePath, "r")   -- Open the file in read mode
  if not file then
    return nil, "Could not open file"
  end

  local content = file:read("*all")   -- Read the entire file contents
  file:close()                        -- Close the file
  return content
end

return {
  ["solar-data"] = function(args, kwargs, meta)
    local object = pandoc.utils.stringify(args[1])

    local template = ""
    local out_type = ""
    local view_model = solar_system[object]

    if quarto.format.is_latex_output() then
      template = templates["tex"]
      view_model["image_path"] = "_extensions/nenuial/lddr-solar/assets/pictures/"

      quarto.doc.use_latex_package("tabularx")
      quarto.doc.use_latex_package("multirow")
      quarto.doc.include_file("in-header", "assets/tex/include.tex")
      out_type = "latex"
    else
      template = templates["html"]
      view_model["image_path"] = "_extensions/nenuial/lddr-solar/assets/pictures/"

      quarto.doc.add_html_dependency({
        name = "solar_style",
        version = "1.0.0",
        stylesheets = { "assets/css/style.css" }
      })
      out_type = "html"
    end

    if args[2] == "en" then
      view_model["name"] = view_model["english"]
      view_model["type"] = view_model["type_en"]
      view_model["translation"] = english_strings
    elseif args[2] == "fr" then
      view_model["name"] = view_model["french"]
      view_model["type"] = view_model["type_fr"]
      view_model["translation"] = french_strings
    end

    output = lustache:render(template, view_model)

    return pandoc.RawBlock(out_type, output)
  end
}
