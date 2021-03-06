shared_examples 'resource_collection' do
  let(:resource_class) { described_class::RESOURCE_NAME.constantize }

  context "#add" do
    it "adds a model record" do
      described_class.add(user).resource_class.should == 'Bustle::Dummy::User'
    end

    it "gets the model if it already exists" do
      described_class.add(user)
      described_class.add(user).should be_kind_of(resource_class)
    end

    it "explicitly adds a model record" do
      described_class.add!(user).should be_kind_of(resource_class)
    end

    it "raises error if the model already exists" do
      described_class.add(user)
      expect { described_class.add!(user) }.to raise_error
    end
  end

  context "get/remove" do
    before do
      described_class.add user
    end

    it "adds a model record" do
      model = resource_class.to_adapter.get(1)
      model.resource_class.should == 'Bustle::Dummy::User'
      model.resource_id.should == 42
    end

    it "finds a model record" do
      model = described_class.get user
      model.resource_class.should == 'Bustle::Dummy::User'
      model.resource_id.should == 42
    end

    it "removes a model record" do
      described_class.remove(user)
      resource_class.to_adapter.find_all({}).count.should == 0
    end

    it "#remove! a model record" do
      described_class.remove!(user)
      resource_class.to_adapter.find_all({}).count.should == 0
    end

    it "#remove! with error" do
      expect { described_class.remove!(post) }.to raise_error
    end
  end
end
