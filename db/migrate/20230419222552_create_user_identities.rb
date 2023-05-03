# typed: ignore
class CreateUserIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_identities, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
