/**
 * @type {import('@types/aws-lambda').CustomMessageTriggerHandler}
 */
exports.handler = async (event) => {
  // Define the URL that you want the user to be directed to after verification is complete
  if (event.triggerSource === "CustomMessage_SignUp") {
    const { codeParameter } = event.request;

    // Provide default subject and message if not set in environment
    const emailSubject =
      process.env.EMAILSUBJECT || "Verify your email for Personal Project";
    const emailMessage =
      process.env.EMAILMESSAGE || "Your verification code is";

    const codeHtml = `<h1 style="font-size:2em;">${codeParameter}</h1>`;
    const message = `${emailMessage}.<br>${codeHtml}`;
    event.response.smsMessage = `${emailMessage}. \n ${codeParameter}`;
    event.response.emailSubject = emailSubject;
    event.response.emailMessage = message;
    console.log("event.response", event.response);
  }

  return event;
};
