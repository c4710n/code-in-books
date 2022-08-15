ExUnit.start()
Code.require_file("10-translator.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  defmodule I18n do
    use Translator

    locale("en",
      foo: "bar",
      flash: [
        hello: "Hello %{first} %{last}!",
        bye: "Bye, %{name}!"
      ],
      users: [
        title: "Users",
        profile: [
          title: "Profiles"
        ]
      ]
    )

    locale("zh",
      foo: "测试",
      flash: [
        hello: "你好，%{first} %{last}！",
        bye: "再见，%{name}！"
      ],
      users: [
        title: "用户",
        profile: [
          title: "用户简介"
        ]
      ]
    )
  end

  test "it handles translations at root level" do
    assert I18n.t("en", "foo") == "bar"
  end

  test "it walks translations tree" do
    assert I18n.t("en", "users.title") == "Users"
    assert I18n.t("en", "users.profile.title") == "Profiles"
  end

  test "it allows multiple locals to be registered" do
    assert I18n.t("en", "foo") == "bar"
    assert I18n.t("zh", "foo") == "测试"
  end

  test "it interpolates bindings" do
    assert I18n.t("zh", "flash.hello", first: "Zeke", last: "Dou") == "你好，Zeke Dou！"
  end

  test "t/3 raises KeyError when bindings not provided" do
    assert_raise KeyError, fn -> I18n.t("en", "flash.hello") end
  end

  test "t/3 returns {:error, :no_translation} when translation is missing" do
    assert I18n.t("en", "flash.not_exists") == {:error, :no_translation}
  end

  test "coverts interpolation values to string" do
    assert I18n.t("zh", "flash.hello", first: "李", last: "34") == "你好，李 34！"
  end

  test "compile/1 generates catch-all t/3 functions" do
    generated_code =
      []
      |> Translator.compile()
      |> Macro.to_string()

    assert generated_code ==
             String.trim(~S"""
             def t(locale, path, bindings \\ [])
             []

             def t(_locale, _path, _bindings) do
               {:error, :no_translation}
             end
             """)
  end

  test "compile/1 generates t/3 functions from each locale" do
    generated_code =
      [{"en", [foo: "bar", bar: "%{baz}"]}]
      |> Translator.compile()
      |> Macro.to_string()

    assert generated_code ==
             String.trim(~S"""
             def t(locale, path, bindings \\ [])

             [
               [
                 def t("en", "foo", bindings) do
                   "" <> "bar"
                 end,
                 def t("en", "bar", bindings) do
                   (("" <> "") <> to_string(Keyword.fetch!(bindings, :baz))) <> ""
                 end
               ]
             ]

             def t(_locale, _path, _bindings) do
               {:error, :no_translation}
             end
             """)
  end
end
