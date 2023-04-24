# Bot teacher: ChatGPT based AI language teacher
### **Chat with characters to practise multiple spoken languages via iOS**

### Key features:
- Voice call to a characters: no need to control button
- Finish tasks while chat with characters
- Support multiple languages
- Generated reports for your conversation
- Support translation for the words; Able to custom your own language
- Lightweight ChatGPT iOS application

### Implementation Details:
1. Class
- Database.swift: save all globale data and sturctures
- GetDataFromCloud.swift: get data from firebase
2. Backend
- Firebase unstructured data storage to save character prompts 
- Configure your own lightweight db via Firebase
- Users db: authentication provided by Firebase
3. Speech services
- Azure speech service
- Customized voice support: AzureServicePostRequest.swift
- Multiple regions router support for Azure: https://github.com/neebdev/load-config-worker


<div style="display: flex; justify-content: center;">
  <img src="https://user-images.githubusercontent.com/50688000/233969017-afa8e597-123c-4a46-b919-900a0a3cad06.jpeg" width="300"/>
  <img src="https://user-images.githubusercontent.com/50688000/233960625-b9149f5f-1a60-469d-96b1-f3cdc263c3e9.jpeg" width="300"/>
  <img src="https://user-images.githubusercontent.com/50688000/233966258-0f91619f-6104-4f1a-b3bf-35261b465a01.jpeg" width="300"/>
</div>

<div style="display: flex; justify-content: center;">
  <img src="https://user-images.githubusercontent.com/50688000/233971563-0615ba81-cdd4-4aa1-b60b-96932c24fd10.PNG" width="300"/>
  <img src="https://user-images.githubusercontent.com/50688000/233971441-e16b304f-12d7-4f2f-b5f8-9a906eb7f821.PNG" width="300"/>
  <img src="https://user-images.githubusercontent.com/50688000/233971780-efc645d8-56c9-446c-bd99-b091f4ff76b9.jpeg" width="300"/>
</div>

