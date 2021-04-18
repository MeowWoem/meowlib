require "MeowCore";

local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");

local elm = UIComponent:new(250, 250, 500, 500);
elm:initialise();
elm:addToUIManager();
elm:setVisible(true);
