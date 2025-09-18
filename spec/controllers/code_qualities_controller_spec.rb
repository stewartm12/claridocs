require 'rails_helper'
require 'redcarpet'


RSpec.describe CodeQualitiesController, type: :controller do
  let(:review_file) do
    instance_double(
      ReviewFile,
      path: Rails.root.join('reviews/code_reviews/feature-branch_2025-09-17.md'),
      filename: 'feature-branch_2025-09-17',
      display_type: 'Code Reviews'
    )
  end

  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      context 'not in development env' do
        it 'redirects to root' do
          get :index

          expect(response).to redirect_to(root_path)
        end
      end

      context 'in development env' do
        before do
          allow(Rails.env).to receive(:development?).and_return(true)
          allow_any_instance_of(Quality::ReviewFileFinder).to receive(:grouped_reviews).and_return([review_file])
        end

        it 'returns a successful response' do
          get :index

          expect(response).to have_http_status(:ok)
          expect(controller.instance_variable_get(:@reviews)).to eq([review_file])
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index
    end

    context 'when user is logged in' do
      include_context 'with authenticated user'

      context 'not in development env' do
        it 'redirects to root' do
          get :index

          expect(response).to redirect_to(root_path)
        end
      end

      context 'in development env' do
        let(:markdown_html) { "<h1>Review Content</h1>" }

        before do
          allow(Rails.env).to receive(:development?).and_return(true)
          allow(Quality::MarkdownRenderer).to receive(:new).with(review_file.path).and_return(double(render: markdown_html))
        end

        context 'when the review file exists' do
          before do
            allow(ReviewFile).to receive(:find_by_filename).with('feature-branch_2025-09-17').and_return(review_file)
          end

          it 'assigns instance variables and renders show' do
            get :show, params: { filename: 'feature-branch_2025-09-17' }

            expect(controller.instance_variable_get(:@review_file)).to eq(review_file)
            expect(controller.instance_variable_get(:@markdown_html)).to eq(markdown_html)
            expect(controller.instance_variable_get(:@filename)).to eq('feature-branch_2025-09-17')
            expect(controller.instance_variable_get(:@review_type)).to eq('Code Reviews')
          end
        end

        context 'when the review file does not exist' do
          before { allow(ReviewFile).to receive(:find_by_filename).with('missing-file').and_return(nil) }

          it 'redirects to index with alert' do
            get :show, params: { filename: 'missing-file' }

            expect(response).to redirect_to(code_qualities_path)
            expect(flash[:alert]).to eq('Review not found')
          end
        end
      end
    end
  end
end
