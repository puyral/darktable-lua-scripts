local dt = require "darktable"
local du = require "lib/dtutils.file"

local function parseIntList(str)
  local result = {}
  for num in string.gmatch(str, '(%d+)') do
    table.insert(result, tonumber(num))
  end
  return result
end


-- Function to filter the collection to show only specified image IDs
local function filter_collection_by_image_ids(image_ids_str)
  -- -- Build a query string to filter by image IDs
  -- local query = "((id == "
  -- query = query .. table.concat(image_ids, ") or (id == ")
  -- query = query .. "))"

  -- -- Apply the filter to the current collection
  -- dt.gui.selection(select_images_by_ids(image_ids))
  -- dt.print("Collection filtered to show specified images.")


  local image_ids = parseIntList(image_ids_str)
  local selected_images = {}
  for _, image_id in ipairs(image_ids) do
    local image = dt.database.get_image(image_id)
    if image then
      table.insert(selected_images, image)
    else
      dt.print(string.format("Image ID %d not found.", image_id))
    end
  end
  dt.gui.selection(selected_images)
end

-- Helper function to retrieve a list of images by their IDs
-- local function select_images_by_ids(image_ids)
--   local selected_images = {}
--   for _, image_id in ipairs(image_ids) do
--     local image = dt.database.get_image(image_id)
--     if image then
--       table.insert(selected_images, image)
--     else
--       dt.print(string.format("Image ID %d not found.", image_id))
--     end
--   end
--   return selected_images
-- end

-- -- Function to prompt user for a list of image IDs to filter the collection
-- local function prompt_filter_collection()
--     -- Ask the user for a comma-separated list of image IDs
--     local image_id_str = dt.gui.inputbox("Enter the image IDs to filter (comma-separated):")
--     local image_ids = {}

--     -- Parse the comma-separated string into a table of image IDs
--     for id in string.gmatch(image_id_str, "%d+") do
--         table.insert(image_ids, tonumber(id))
--     end

--     -- Filter the collection to show the specified images
--     filter_collection_by_image_ids(image_ids)
-- end

-- Register the script to be run from the "Scripts" menu
-- dt.register_event("shortcut", prompt_filter_collection, "Filter collection by image IDs")


local mfilter = {}
mfilter.ids = dt.new_widget("entry") {
  tooltip = "comma separated list of image ids",
  placeholder = "comma separated list of image ids",
  text = "",
}
mfilter.bt = dt.new_widget("button") {
  label = "Search",
  tooltip = "search for the selected images",
  sensitive = false,
  clicked_callback = function()
    filter_collection_by_image_ids(mfilter.ids.text)
  end
}
mfilter.widget = dt.new_widget("box") {
  orientation = "vertical",
  mfilter.ids,
  mfilter.bt
}

dt.register_lib(
  "search_by_ids",
  "Search by ids",
  true,
  false,
  { [dt.gui.views.lighttable] = { "DT_UI_CONTAINER_PANEL_RIGHT_CENTER", 100 } },
  mfilter.widget,
  nil, nil
)
