# module DocumentTypeMappings
#   extend ActiveSupport::Concern

#   included do
#     enum :document_type, {
#       misc: 0, pdf: 1, doc: 2, docx: 3, txt: 4,
#       rtf: 5, xls: 6, xlsx: 7, ppt: 8, pptx: 9, md: 10
#     }
#   end

#   MIME_TO_ENUM = {
#     'application/pdf' => :pdf,
#     'application/msword' => :doc,
#     'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => :docx,
#     'text/plain' => :txt,
#     'application/rtf' => :rtf,
#     'application/vnd.ms-excel' => :xls,
#     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => :xlsx,
#     'application/vnd.ms-powerpoint' => :ppt,
#     'application/vnd.openxmlformats-officedocument.presentationml.presentation' => :pptx,
#     'text/markdown' => :md
#   }.freeze

#   DOCUMENT_TYPE_LABELS = {
#     pdf:  'PDF',
#     doc:  'Word (.doc)',
#     docx: 'Word (.docx)',
#     txt:  'Text',
#     rtf:  'Rich Text',
#     xls:  'Excel (.xls)',
#     xlsx: 'Excel (.xlsx)',
#     ppt:  'PowerPoint (.ppt)',
#     pptx: 'PowerPoint (.pptx)',
#     md:   'Markdown (.md)',
#     misc: 'Other'
#   }.freeze

#   class_methods do
#     def from_mime(mime_type)
#       MIME_TO_ENUM.fetch(mime_type, :misc)
#     end

#     def options_for_select
#       DOCUMENT_TYPE_LABELS.map { |key, label| [label, key] }
#     end
#   end
# end
