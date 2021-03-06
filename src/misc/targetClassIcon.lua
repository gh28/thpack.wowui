(function()

    local function createBlizzardRoundButton(parent, template, size)
        local button = CreateFrame("Button", nil, parent, template);
        button:SetSize(size, size);

        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT");
        highlightTexture:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]]);
        highlightTexture:SetPoint("TOPLEFT", size * -1/64, size * 1/64);
        highlightTexture:SetPoint("BOTTOMRIGHT", size * -1/64, size * 1/64);
        button:SetHighlightTexture(highlightTexture);

        local backgroundTexture = button:CreateTexture(nil, "BACKGROUND");
        backgroundTexture:SetTexture([[Interface\Minimap\UI-Minimap-Background]]);
        backgroundTexture:SetVertexColor(0, 0, 0, 0.6);
        backgroundTexture:SetPoint("TOPLEFT", size * 4/64, "TOPLEFT", size * -4/64);
        backgroundTexture:SetPoint("BOTTOMRIGHT", size * -4/64, "TOPLEFT", size * 4/64);

        local borderTexture = button:CreateTexture(nil, "OVERLAY");
        borderTexture:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]]);
        borderTexture:SetTexCoord(0, 38/64, 0, 38/64);
        borderTexture:SetAllPoints();

        local artworkTexture = button:CreateTexture(nil, "ARTWORK");
        artworkTexture:SetPoint("TOPLEFT", size * 12/64, size * -10/64);
        artworkTexture:SetPoint("BOTTOMRIGHT", size * -12/64, size * 14/64);
        button.artworkTexture = artworkTexture;

        return button;
    end

    local classIcon = createBlizzardRoundButton(TargetFrame, nil, 40);
    classIcon:SetPoint("topleft", 115, -3); -- no pixel fix since align to bliz mod
    RaiseFrameLevel(classIcon);
    classIcon.artworkTexture:SetTexture([[Interface\WorldStateFrame\Icons-Classes]]);

    -- inspect target when click
    classIcon:SetScript("OnMouseDown", function(self, button)
        if (button == "LeftButton") then
            local unit = "target";
            if (UnitIsPlayer(unit)) and not UnitCanAttack("player", unit) then
                if (InspectFrame and InspectFrame:IsShown()) then
                    InspectFrameCloseButton:Click();
                else
                    InspectUnit(unit);
                end
            end
        end
    end);

    function classIcon:onChangeTarget()
        local unit = "target";
        if (UnitIsPlayer(unit)) then
            local unitClass = select(2, UnitClass(unit));
            self.artworkTexture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]));
            self:Show();
        else
            self:Hide();
        end
    end

    classIcon:RegisterEvent("PLAYER_TARGET_CHANGED");
    classIcon:SetScript("OnEvent", classIcon.onChangeTarget);

    classIcon:onChangeTarget();
end)();
