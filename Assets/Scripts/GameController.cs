using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
enum GameState
{
    QUESTION,
    COMMAND,
    REVEAL,
    DECISION,
    CAPTURED,
}

public class GameController : MonoBehaviour {

    public GameObject textBackground;
    public Renderer humanRenderer = null;
    public TMPro.TextMeshProUGUI mainText;
    public TMPro.TextMeshProUGUI statsText;
    public GameObject capturedPanel;
    public ParticleSystem particlesFire;
    public ParticleSystem particlesIce;
    public GameObject endNoise;
    public Button yesButton;
    public Button noButton;
    public int humanIndex = 0;
    public int falseAccusations = 0;

    public AudioSource audioPlayer;
    public AudioClip endThemeClip;

    public bool isPrometheus = false;
    public Color matchQuestionColor;

    GameState state = GameState.QUESTION;

    GameState State 
    {
        get { return state; }
        set 
        {
            humanRenderer.material.SetFloat("_NoiseLerp", 0);
            particlesFire.enableEmission = false;
            particlesIce.enableEmission = false;
            yesButton.gameObject.SetActive(false);
            noButton.gameObject.SetActive(false);
            capturedPanel.SetActive(false);
            textBackground.gameObject.SetActive(false);
            endNoise.SetActive(false);
            audioPlayer.volume = 0;
            switch (value)
            {
                case GameState.QUESTION:
                    textBackground.gameObject.SetActive(true);
                    mainText.text = "Another one!!!";
                    break;
                case GameState.COMMAND:
                    textBackground.gameObject.SetActive(true);
                    //Generate new body
                    if (humanIndex == 0)
                    {
                        isPrometheus = false;
                    }
                    else
                    {
                        isPrometheus = Random.value > 0.5f;
                    }
                    mainText.text = "Got a light!?\nSHED THY CLOTHES!!!";
                    statsText.text = "FALSE ACCUSATIONS: " + falseAccusations;
                    
                    break;
                case GameState.REVEAL:
                    audioPlayer.volume = 1;
                    audioPlayer.Play();
                    textBackground.gameObject.SetActive(false);
                    humanRenderer.material.SetFloat("_NoiseLerp", 1);
                    particlesFire.enableEmission = isPrometheus;
                    particlesIce.enableEmission = isPrometheus == false;
                    mainText.text = "...";
                    StartCoroutine("RevealRoutine");
                    break;
                case GameState.DECISION:
                    textBackground.gameObject.SetActive(true);
                    yesButton.gameObject.SetActive(true);
                    noButton.gameObject.SetActive(true);
                    string hexParamColor = ColorUtility.ToHtmlStringRGB(matchQuestionColor);
                    mainText.text = string.Format("Does this one carry a <color=#{0}>light</color>?", hexParamColor);
                    break;
                case GameState.CAPTURED:
                    audioPlayer.volume = 1;
                    audioPlayer.clip = endThemeClip;
                    audioPlayer.Play();
                    textBackground.gameObject.SetActive(true);
                    mainText.gameObject.SetActive(false);
                    capturedPanel.SetActive(true);
                    endNoise.SetActive(true);
                    humanRenderer.gameObject.SetActive(false);
                    break;
            }
            state = value;
        }

    }
   

    IEnumerator RevealRoutine()
    {
        yield return new WaitForSeconds(5f);
        State = GameState.DECISION;
    }

    // Use this for initialization
    void Start () {
        State = GameState.QUESTION;
	}
	
	// Update is called once per frame
	void Update () {
		switch (state)
        {

            case GameState.QUESTION:
                if (Input.GetKeyDown(KeyCode.Mouse0))
                {
                    State = GameState.COMMAND;
                }
                break;
            case GameState.COMMAND:
                if (Input.GetKeyDown(KeyCode.Mouse0))
                {
                    State = GameState.REVEAL;
                }
                break;
            case GameState.REVEAL:

                //TODO: Remove manual control, add delay & transition to decision
                if (Input.GetKeyDown(KeyCode.Mouse0))
                {
                    StopAllCoroutines();
                    State = GameState.DECISION;
                }
                break;
            case GameState.DECISION:
                break;
        }
	}

    public void QuessedYes()
    {

        if (isPrometheus)
        {
            State = GameState.CAPTURED;
        }
        else
        {
            falseAccusations++;
            humanIndex++;
            State = GameState.QUESTION;
        }
    }

    public void QuessedNo()
    {
        if (isPrometheus)
        {
            falseAccusations++;
        }
        humanIndex++;
        State = GameState.QUESTION;
    }
}
