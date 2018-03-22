class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :reporter_id, null: false
      t.integer :reportee_id, null: false
      t.integer :status, default: 1
      t.integer :comment_id
      t.string :note
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
