# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_25_042400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.jsonb "imgur_response"
    t.string "imgur_url"
    t.datetime "imgur_sync_at"
    t.string "title"
    t.boolean "published", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "video_collection"
  end

  create_table "quick_vote_topics", force: :cascade do |t|
    t.bigint "streamer_id", null: false
    t.string "topic"
    t.boolean "active", default: false
    t.integer "last_counter", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["streamer_id"], name: "index_quick_vote_topics_on_streamer_id"
  end

  create_table "quick_votes", force: :cascade do |t|
    t.bigint "streamer_id", null: false
    t.bigint "user_id", null: false
    t.integer "value", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["streamer_id"], name: "index_quick_votes_on_streamer_id"
    t.index ["user_id"], name: "index_quick_votes_on_user_id"
  end

  create_table "stream_mods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "streamer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["streamer_id"], name: "index_stream_mods_on_streamer_id"
    t.index ["user_id"], name: "index_stream_mods_on_user_id"
  end

  create_table "stream_rewards", force: :cascade do |t|
    t.bigint "streamer_id", null: false
    t.string "uid"
    t.string "image"
    t.string "background_color"
    t.boolean "is_enabled", default: true
    t.integer "cost", default: 5000
    t.string "title"
    t.string "prompt"
    t.boolean "is_user_input_required", default: true
    t.boolean "max_per_stream_enabled", default: false
    t.integer "max_per_stream"
    t.boolean "max_per_user_per_stream_enabled", default: false
    t.integer "max_per_user_per_stream"
    t.boolean "global_cooldown_enabled", default: false
    t.integer "global_cooldown_seconds"
    t.boolean "is_paused", default: false
    t.boolean "is_in_stock", default: true
    t.string "default_image_1x"
    t.string "default_image_2x"
    t.string "default_image_3x"
    t.boolean "should_redemptions_skip_request_queue", default: false
    t.string "cooldown_expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["streamer_id"], name: "index_stream_rewards_on_streamer_id"
  end

  create_table "streamers", force: :cascade do |t|
    t.string "uid"
    t.string "channel_name"
    t.string "avatar_url"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "daily_limit", default: 15
    t.integer "tts_cooldown", default: 300
  end

  create_table "tts_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "streamer_id", null: false
    t.string "text_to_speach"
    t.boolean "pending", default: true
    t.boolean "accepted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "category"
    t.index ["streamer_id"], name: "index_tts_items_on_streamer_id"
    t.index ["user_id"], name: "index_tts_items_on_user_id"
  end

  create_table "user_streamers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "streamer_id", null: false
    t.datetime "follow_date"
    t.jsonb "subscription_data"
    t.datetime "subscription_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_uid"
    t.boolean "subscription_active", default: false
    t.boolean "is_following", default: false
    t.index ["streamer_id"], name: "index_user_streamers_on_streamer_id"
    t.index ["user_id"], name: "index_user_streamers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_url"
    t.string "google_uid"
    t.string "twitch_uid"
    t.string "discord_uid"
    t.string "facebook_uid"
    t.integer "birth_day"
    t.integer "birth_month"
    t.string "discord_tag"
    t.string "country"
    t.integer "points", default: 100
    t.boolean "onboarding_complete", default: false
    t.string "token"
    t.string "refresh_token"
    t.integer "token_date"
    t.string "discord_token"
    t.string "discord_refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "quick_vote_topics", "streamers"
  add_foreign_key "quick_votes", "streamers"
  add_foreign_key "quick_votes", "users"
  add_foreign_key "stream_mods", "streamers"
  add_foreign_key "stream_mods", "users"
  add_foreign_key "stream_rewards", "streamers"
  add_foreign_key "tts_items", "streamers"
  add_foreign_key "tts_items", "users"
  add_foreign_key "user_streamers", "streamers"
  add_foreign_key "user_streamers", "users"
end
