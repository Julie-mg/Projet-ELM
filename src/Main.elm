module Main exposing (..)

import Browser
import Random
import Json.Decode exposing (Decoder, map2, field, string, list)
import Json.Decode exposing (Error(..))
import Html.Attributes exposing (selected, placeholder, value)
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Array
import String exposing (String)

import Json.Decode exposing (Decoder, map2, field, string, list)
import Json.Decode exposing (Error(..))

type alias Model =
    { selected : String
    , list: List String
    , response: List Response
    , guess: String
    }

type alias Response = 
  { word: String
  , meanings: List Meaning
  }

type alias Meaning = 
  { partOfSpeech: String
  , definitions: List Definition
  }

type alias Definition = 
  { definition: String
  }

type Msg
    = FindRandom
    | RandomNumber Int
    | GotText (Result Http.Error String)
    | GotResponse (Result Http.Error (List Response))
    | Change String
    | ShowWord

init : () -> (Model, Cmd Msg)
init flags =
    ({selected = " ", list = [], response = [], guess = ""},
    Http.get
      { url = "http://localhost:8000/ELM/words.txt"
      , expect = Http.expectString GotText
      }
    )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FindRandom ->
            ({model | guess = ""}, Random.generate RandomNumber (Random.int 0 (List.length model.list - 1)))
        RandomNumber rn ->
            let
                selected = Array.fromList model.list
                    |> Array.get rn
                    |> Maybe.withDefault ""
            in
                case selected of
                  "" -> (model, Cmd.none)
                  _ -> 
                      let
                          newModel = { model | selected = selected }
                      in
                          (newModel, getResponse selected)
        GotText result ->
          case result of
            Ok fullText ->
              ({ model | list = textToList fullText}, Random.generate RandomNumber (Random.int 0 (List.length model.list - 1)))
            Err _ ->
              (model, Cmd.none)

        GotResponse result ->
          case result of
            Ok responses ->
              ({ model | response = responses}, Cmd.none)

            Err error ->
              (model, Cmd.none)

        Change newContent ->
          if newContent == model.selected then
            ({ model | guess = newContent }, Cmd.none)
          else
            ({ model | guess = newContent }, Cmd.none)

        ShowWord ->
            ({ model | guess = model.selected }, Cmd.none)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Guess it!" ]
    , if model.selected == " " then gotStart model else if model.guess == model.selected then gotRight model else gotResponse model
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

gotResponse : Model -> Html Msg
gotResponse result =
      div []
        [ h3 [] [ text "Definition" ]
        , ul [] (List.map viewResponse result.response)
        , input [ placeholder "Guess", value result.guess, onInput Change ] []
        ,  button [ onClick FindRandom]  [ text "Next Word" ]
        , button [ onClick ShowWord ] [ text "Show Word" ]
        ]

gotRight : Model -> Html Msg
gotRight result =
      div []
        [ h3 [] [ text result.selected ]
        , ul [] (List.map viewResponse result.response)
        , input [ placeholder "Guess", value result.guess, onInput Change ] []
        ,  button [ onClick FindRandom]  [ text "Next Word" ]
        , button [ onClick ShowWord ] [ text "Show Word" ]
        , ul [] [ text "You're right, congrats!" ]
        ]

gotStart : Model -> Html Msg
gotStart result =
      div []
        [ h3 [] [ text result.selected ]
        , ul [] (List.map viewResponse result.response)
        , ul [] [ text "Click on the start button to begin" ]
        ,  button [ onClick FindRandom]  [ text "Start" ]
        ]

viewResponse : Response -> Html Msg
viewResponse response =
  div[]
    [ li [] (List.map viewMeaning response.meanings)
    ]

viewMeaning : Meaning -> Html Msg
viewMeaning meaning =
  div[]
    [ li [] [ text meaning.partOfSpeech ]
    , ol [] (List.map viewDefinition meaning.definitions)
    ]

viewDefinition : Definition -> Html Msg
viewDefinition definition =
    li [] [ text definition.definition ]

textToList : String -> List String
textToList msg =
    String.words msg

getResponse : String -> Cmd Msg
getResponse word =
  Http.get
    { url = "https://api.dictionaryapi.dev/api/v2/entries/en/" ++ word
    , expect = Http.expectJson GotResponse listDecoder
    }

definitionDecoder: Decoder Definition
definitionDecoder = 
  Json.Decode.map Definition
    (field "definition" string)

meaningDecoder: Decoder Meaning
meaningDecoder =
  map2 Meaning
    (field "partOfSpeech" string)
    (field "definitions" (list definitionDecoder))

responseDecoder: Decoder Response
responseDecoder =
  map2 Response
    (field "word" string)
    (field "meanings" (list meaningDecoder))

listDecoder: Decoder (List Response)
listDecoder = 
  list responseDecoder