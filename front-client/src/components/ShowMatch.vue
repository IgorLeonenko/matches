<template>
  <div id='match'>
    <h2>Match</h2>
    <table v-if='match'>
      <thead>
        <tr>
          <td>Home team</td>
          <td>Invited team</td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <p>Name: {{match.home_team.name}}</p>
            <p>Score: {{match.home_team_score}}</p>
            <p>Players:
              <ul v-for='user in match.home_team.users'>
                <li>{{user.username}}</li>
              </ul>
            </p>
          </td>
          <td>
            <p>Name: {{match.invited_team.name}}</p>
            <p>Score: {{match.invited_team_score}}</p>
            <p>Players:
              <ul v-for='user in match.invited_team.users'>
                <li>{{user.username}}</li>
              </ul>
            </p>
          </td>
        </tr>
      </tbody>
    </table>
    <button type='button' @click="goBack()">Back</button>
  </div>
</template>

<script>
  import api from '../api'
  import { router } from '../main'
  export default {
    name: 'Match',
    data () {
      return {
        match: null
      }
    },
    mounted () {
      api.getMatch(this.$route.params.id).then(response => {
        this.match = response.data
      })
    },
    methods: {
      goBack () {
        router.push('/matches')
      }
    }
  }
</script>

<style scoped>
  ul {
    list-style: none;
  }
</style>
