# frozen_string_literal: true

ActiveAdmin.register Post do
  permit_params :author_id, :title, :description, :category, :dt, :position, :published, tag_ids: []

  member_action :upload, method: [:post] do
    success = resource.images.attach(params[:file_upload])
    result = success ? { link: url_for(resource.images.last) } : {}
    render json: result
  end

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :published
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :author
      row :title
      row :description
      row :category
      row :dt
      row :position
      row :published
      row :tags
      row :created_at
      row :updated_at
      row :images do |resurce|
        resurce.images.each do |image|
          div do
            link_to image.filename, image, target: '_blank'
          end
        end
        nil
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Post' do
      f.input :author
      f.input :title
      unless resource.new_record?
        f.input :description, as: :froala_editor, input_html: { data: { options: { imageUploadParam: 'file_upload', imageUploadURL: upload_admin_post_path(resource.id), toolbarButtons: %w[bold italic underline | insertImage insertVideo insertFile] } } }
      end
      f.input :category
      f.input :dt
      f.input :position
      f.input :published
    end

    f.inputs 'Tags' do
      f.input :tags
    end

    f.actions
  end
end
