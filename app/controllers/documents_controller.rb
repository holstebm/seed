class DocumentsController < ApplicationController
  
  layout nil
  before_filter :login_required
  
  def new
    @document = Document.new
  end
  
  def create
    @document = Document.new(params[:document])
    if @document.save
      responds_to_parent do
        render :update do |page|
            page << "Lightview.hide();"
            page.insert_html :top, 'document-table', :partial => "documents/document", :object => @document
            page.insert_html :top, 'document-ids', hidden_field_tag("component[document_ids][]", @document.id, :id => "hidden_document_tag_#{@document.id}")
            page.insert_html :top, 'ajax-msg', "<div id='flash-notice'>Document was successfully uploaded</div>"
        end
      end          
    else
      responds_to_parent do
        render :update do |page|
            page["spinner"].hide
            page.insert_html :top, 'ajax-error', @document.errors.collect{|k,v| "<li>The #{k} #{v}</li>"}.to_s
        end
      end          
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    
    render :update do |page|
      page.remove "document_#{@document.id}"
      page.remove "hidden_document_tag_#{@document.id}"
    end
    
  end
  
end
