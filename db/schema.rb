# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_03_18_010804) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "card_collection_comments", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "card_collection_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deleted", default: false, null: false
  end

  create_table "card_collection_hashtags", force: :cascade do |t|
    t.integer "card_collection_id", null: false
    t.integer "hashtag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_collection_id", "hashtag_id"], name: "index_card_collection_hashtags_on_card_collection_and_hashtag", unique: true
    t.index ["card_collection_id"], name: "index_card_collection_hashtags_on_card_collection_id"
    t.index ["hashtag_id"], name: "index_card_collection_hashtags_on_hashtag_id"
  end

  create_table "card_collection_replies", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "card_collection_comment_id"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_reply_id"
    t.index ["card_collection_comment_id"], name: "index_card_collection_replies_on_card_collection_comment_id"
    t.index ["parent_reply_id"], name: "index_card_collection_replies_on_parent_reply_id"
    t.index ["user_id"], name: "index_card_collection_replies_on_user_id"
  end

  create_table "card_collections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "contents"
    t.string "layout"
    t.string "theme"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "photo_order"
    t.index ["user_id"], name: "index_card_collections_on_user_id"
  end

  create_table "card_images", force: :cascade do |t|
    t.integer "card_collection_id", null: false
    t.text "content"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_collection_id"], name: "index_card_images_on_card_collection_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_hashtags_on_name", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "likeable_type", null: false
    t.integer "likeable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname", default: "", null: false
    t.boolean "terms_of_service", default: false, null: false
    t.boolean "privacy_policy", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "introduction"
    t.date "birth_date"
    t.string "phone_number"
    t.string "gender"
    t.string "sns_link"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "card_collection_hashtags", "card_collections"
  add_foreign_key "card_collection_hashtags", "hashtags"
  add_foreign_key "card_collections", "users"
  add_foreign_key "card_images", "card_collections"
  add_foreign_key "likes", "users"
end
