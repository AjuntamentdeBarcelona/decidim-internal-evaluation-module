# frozen_string_literal: true

class ChangeInternalEvaluationsBodyToText < ActiveRecord::Migration[7.0]
  def up
    change_column :decidim_internal_evaluation_internal_evaluations, :body, :text
  end

  def down
    change_column :decidim_internal_evaluation_internal_evaluations, :body, :jsonb
  end
end
