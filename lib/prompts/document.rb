module Prompts::Document
  extend self

  def summary(document_text)
    <<~PROMPT
      Summarize the following document.
      Provide a concise overview that highlights the purpose, key details, and any important actions or outcomes.
      Limit the summary from 3 to 5 sentences.
      Do not include extra commentary outside of the summary.

      Document: #{document_text}
    PROMPT
  end

  def info_extraction(document_text)
    <<~PROMPT
      Analyze the following document and extract key metadata and structured information.

    Your output must always be a valid JSON object.

    - Include key sections if they are present (e.g., document_metadata, parties_information, contract_terms, financial_terms, confidential_information).
    - If a section does not exist in the document, omit it entirely (do not return empty objects).
    - If the document contains other important categories not listed above, add them as new top-level keys.
    - Ensure all nested objects and arrays are well-structured JSON.
    - Do not include explanations, only JSON.

      Document: #{document_text}
    PROMPT
  end
end
