local dt = require "darktable"
local du = require "lib/dtutils.file"

-- Function to filter the collection to show only specified image IDs
local function filter_collection_by_image_ids(image_ids)
    -- Build a query string to filter by image IDs
    local query = "((id == "
    query = query .. table.concat(image_ids, ") or (id == ")
    query = query .. "))"

    -- Apply the filter to the current collection
    dt.gui.selection(select_images_by_ids(image_ids))
    dt.print("Collection filtered to show specified images.")
end

-- Helper function to retrieve a list of images by their IDs
local function select_images_by_ids(image_ids)
    local selected_images = {}
    for _, image_id in ipairs(image_ids) do
        local image = dt.database.get_image(image_id)
        if image then
            table.insert(selected_images, image)
        else
            dt.print(string.format("Image ID %d not found.", image_id))
        end
    end
    return selected_images
end

-- Function to prompt user for a list of image IDs to filter the collection
local function prompt_filter_collection()
    -- Ask the user for a comma-separated list of image IDs
    local image_id_str = dt.gui.inputbox("Enter the image IDs to filter (comma-separated):")
    local image_ids = {}

    -- Parse the comma-separated string into a table of image IDs
    for id in string.gmatch(image_id_str, "%d+") do
        table.insert(image_ids, tonumber(id))
    end

    -- Filter the collection to show the specified images
    filter_collection_by_image_ids(image_ids)
end

-- Register the script to be run from the "Scripts" menu
dt.register_event("shortcut", prompt_filter_collection, "Filter collection by image IDs")
