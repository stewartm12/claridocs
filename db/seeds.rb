# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ai_int_1 = AiIntegration.find_or_create_by!(name: 'OpenAI', provider: 'open_ai', description: 'Access OpenAI’s GPT and embedding models directly from your account.')

AiModel.find_or_create_by!(ai_integration: ai_int_1, provider: 'open_ai', name: 'gpt-5', category: 'chat', description: 'The best model for coding and agentic tasks across domains')
AiModel.find_or_create_by!(ai_integration: ai_int_1, provider: 'open_ai', name: 'gpt-5-nano', category: 'chat', description: 'Fastest, most cost-efficient version of GPT-5')
AiModel.find_or_create_by!(ai_integration: ai_int_1, provider: 'open_ai', name: 'gpt-5-mini', category: 'chat', description: 'A faster, cost-efficient version of GPT-5 for well-defined tasks')
AiModel.find_or_create_by!(ai_integration: ai_int_1, provider: 'open_ai', name: 'gpt-4.1', category: 'chat', description: 'Smartest non-reasoning model')
AiModel.find_or_create_by!(ai_integration: ai_int_1, provider: 'open_ai', name: 'text-embedding-3-small', category: 'embedding', description: 'Small embedding model')
