class NewMysqlDb < ActiveRecord::Migration
  def change
    create_table "albums", force: :cascade do |t|
      t.string   "name"
      t.datetime "start"
      t.datetime "end"
      t.string   "make"
      t.string   "model"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "country"
      t.string   "city"
      t.string   "photo_ids"
    end

    create_table "catalogs", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "path"
      t.boolean  "default"
      t.string   "watch_path"
      t.string   "type"
    end

    create_table "doubles", force: :cascade do |t|
      t.text     "items"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer  "deleted"
    end

    create_table "instances", force: :cascade do |t|
      t.integer "photo_id"
      t.integer "catalog_id"
      t.string  "path"
    end

    add_index "instances", ["photo_id", "catalog_id"], name: "index_instances_on_photo_id_and_catalog_id", unique: true

    create_table "locations", force: :cascade do |t|
      t.string   "status"
      t.float    "latitude"
      t.float    "longitude"
      t.string   "location"
      t.string   "country"
      t.string   "state"
      t.string   "address"
      t.string   "road"
      t.string   "city"
      t.string   "suburb"
      t.string   "postcode"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "photos", force: :cascade do |t|
      t.string   "filename"
      t.datetime "date_taken"
      t.string   "path"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
      t.string   "file_thumb_path"
      t.string   "file_extension"
      t.integer  "file_size"
      t.integer  "location_id"
      t.string   "make"
      t.string   "model"
      t.integer  "original_height"
      t.integer  "original_width"
      t.decimal  "longitude"
      t.decimal  "latitude"
      t.integer  "status"
    end

    add_index "photos", ["location_id"], name: "index_photos_on_location_id"
    
  end
end
