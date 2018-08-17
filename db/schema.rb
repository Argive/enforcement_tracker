# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180817201424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facilities", force: :cascade do |t|
    t.bigint "registry_id"
    t.string "fac_name"
    t.string "fac_street"
    t.string "fac_city"
    t.string "fac_state"
    t.integer "fac_zip"
    t.integer "fac_epa_region"
    t.float "fac_lat"
    t.float "fac_long"
    t.string "fac_naics_codes"
    t.integer "fac_inspection_count"
    t.string "fac_date_last_inspection"
    t.integer "fac_informal_count"
    t.string "fac_date_last_informal_action"
    t.integer "fac_formal_action_count"
    t.string "fac_date_last_formal_action"
    t.bigint "fac_total_penalties"
    t.integer "fac_penalty_count"
    t.string "fac_date_last_penalty"
    t.bigint "fac_last_penalty_amount"
    t.integer "caa_evaluation_count"
    t.integer "caa_informal_count"
    t.integer "caa_formal_action_count"
    t.bigint "caa_penalties"
    t.integer "cwa_inspection_count"
    t.integer "cwa_informal_count"
    t.integer "cwa_formal_action_count"
    t.bigint "cwa_penalties"
    t.integer "rcra_inspection_count"
    t.integer "rcra_informal_count"
    t.integer "rcra_formal_action_count"
    t.bigint "rcra_penalties"
    t.integer "sdwa_informal_count"
    t.integer "sdwa_formal_action_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dfr_url"
    t.index ["registry_id"], name: "index_facilities_on_registry_id", unique: true
  end

end
