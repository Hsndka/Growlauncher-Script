local workerURL = "https://dc-webhooks.hsndika.workers.dev/"

local function urlEncode(str)
    return tostring(str):gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

local function send(url)
    return fetch(url)
end

local Webhook = {}

-- =========================================
-- MENTION
-- =========================================

function Webhook.mention(userID)
    return "<@" .. tostring(userID) .. ">"
end

-- =========================================
-- PESAN BIASA
-- =========================================

setmetatable(Webhook, {
    __call = function(_, message)
        return send(
            workerURL
            .. "/?mode=text"
            .. "&message="
            .. urlEncode(message)
        )
    end
})

-- =========================================
-- EMBED
-- =========================================

function Webhook.embed(title, description)

    local embed = {
        title = title,
        description = description,
        fields = {},
        mentions = {}
    }

    -- =====================================
    -- COLOR
    -- =====================================

    function embed:color(value)
        self._color = value
        return self
    end

    -- =====================================
    -- FOOTER
    -- =====================================

    function embed:footer(text)
        self._footer = text
        return self
    end

    -- =====================================
    -- THUMBNAIL
    -- =====================================

    function embed:thumbnail(url)
        self._thumbnail = url
        return self
    end

    -- =====================================
    -- IMAGE
    -- =====================================

    function embed:image(url)
        self._image = url
        return self
    end

    -- =====================================
    -- FIELD
    -- =====================================

    function embed:field(name, value, inline)
        table.insert(self.fields, {
            name = name,
            value = value,
            inline = inline or false
        })

        return self
    end

    -- =====================================
    -- MENTION
    -- =====================================

    function embed:mention(userID)
        table.insert(self.mentions, tostring(userID))
        return self
    end

    -- =====================================
    -- SEND
    -- =====================================

    function embed:send()

        local url = workerURL .. "/?mode=embed"

        -- Title
        if self.title then
            url = url
                .. "&title="
                .. urlEncode(self.title)
        end

        -- Description
        if self.description then
            url = url
                .. "&message="
                .. urlEncode(self.description)
        end

        -- Color
        if self._color then
            url = url
                .. "&color="
                .. tostring(self._color)
        end

        -- Footer
        if self._footer then
            url = url
                .. "&footer="
                .. urlEncode(self._footer)
        end

        -- Thumbnail
        if self._thumbnail then
            url = url
                .. "&thumbnail="
                .. urlEncode(self._thumbnail)
        end

        -- Image
        if self._image then
            url = url
                .. "&image="
                .. urlEncode(self._image)
        end

        -- Fields
        for _, field in ipairs(self.fields) do

            url = url
                .. "&field_name="
                .. urlEncode(field.name)

                .. "&field_value="
                .. urlEncode(field.value)

                .. "&field_inline="
                .. tostring(field.inline)

        end

        -- Mentions
        for _, userID in ipairs(self.mentions) do
            url = url
                .. "&mention="
                .. urlEncode(userID)
        end

        return send(url)
    end

    return embed
end

return Webhook
