using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum GameState
{
    QUESTION,
    COMMAND,
    REVEAL,
    DECISION,
    
}

public class GameController : MonoBehaviour {

    public TMPro.TextMeshProUGUI mainText;

    GameState state = GameState.QUESTION;

    GameState State 
    {
        get { return state; }
        set 
        {
            switch (value)
            {
                case GameState.QUESTION:
                    humanRenderer.material.SetFloat("_NoiseAmount", 0);
                    mainText.text = "Got a match?";
                    break;
                case GameState.COMMAND:
                    humanRenderer.material.SetFloat("_NoiseAmount", 0);
                    mainText.text = "SHED THY CLOTHES!!!";
                    break;
                case GameState.REVEAL:
                    humanRenderer.material.SetFloat("_NoiseAmount", 1);
                    mainText.text = "...";
                    break;
                case GameState.DECISION:
                    humanRenderer.material.SetFloat("_NoiseAmount", 0);
                    mainText.text = "Does he posess a match?";
                    break;
            }
            state = value;
        }

    }
    
    [SerializeField] private Renderer humanRenderer = null;


	// Use this for initialization
	void Start () {
        State = GameState.REVEAL;
	}
	
	// Update is called once per frame
	void Update () {
		switch (state)
        {

            case GameState.QUESTION:
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.COMMAND;
                }
                break;
            case GameState.COMMAND:
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.REVEAL;
                }
                break;
            case GameState.REVEAL:

                //TODO: Remove manual control, add delay & transition to decision
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.DECISION;
                }
                break;
            case GameState.DECISION:
                break;
        }


	}
}
